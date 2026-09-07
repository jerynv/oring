import BackgroundTasks
import Foundation

/// iOS chooses the actual wake time. The request asks for an opportunity no
/// earlier than one hour; foreground entry and a five-minute timer cover use.
@MainActor
final class BackgroundSync {
    static let shared = BackgroundSync()
    static let identifier = "com.jerynv.oring.sync"
    private init() {}

    func register() {
        let registered = BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.identifier, using: .main
        ) { task in
            Task { @MainActor in
                guard let task = task as? BGProcessingTask else {
                    task.setTaskCompleted(success: false)
                    return
                }
                self.handle(task)
            }
        }
        if !registered { dlog("background", "sync task registration failed") }
    }

    func schedule() {
        guard Keychain.loadKey() != nil else { return }
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.identifier)
        let request = BGProcessingTaskRequest(identifier: Self.identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
        request.requiresExternalPower = false
        request.requiresNetworkConnectivity = false
        do {
            try BGTaskScheduler.shared.submit(request)
            dlog("background", "requested next sync opportunity in at least one hour")
        } catch {
            dlog("background", "could not schedule sync: \(error)")
        }
    }

    func cancel() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.identifier)
    }

    private func handle(_ task: BGProcessingTask) {
        schedule() // keep the next opportunity even if this one expires
        WorkCoordinator.shared.allowBackgroundWork = true
        var finished = false
        let finish: @MainActor (Bool) -> Void = { success in
            guard !finished else { return }
            finished = true
            WorkCoordinator.shared.allowBackgroundWork = false
            task.setTaskCompleted(success: success)
        }
        task.expirationHandler = {
            Task { @MainActor in
                RingSync.shared.pause()
                finish(false)
            }
        }
        Task { @MainActor in
            let report = await RingSync.shared.syncAutomaticallyIfNeeded()
            finish(report != nil)
        }
    }
}
