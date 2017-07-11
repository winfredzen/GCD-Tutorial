import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Group of Tasks
/*
 // 假装是网络请求
 func networkRequest(sleepTime: Int, closure: @escaping ()->Void) -> Void {
 DispatchQueue.global().async {
 Thread.sleep(forTimeInterval: TimeInterval(sleepTime))
 // 假装是成功回调
 closure()
 }
 }
 
 // 利用 enter/leave 来控制
 func gcd_group_enter_leave() {
 let group = DispatchGroup.init()
 let queue = DispatchQueue.global()
 
 queue.async(group: group) {
 group.enter()
 print("1 start")
 networkRequest(sleepTime:5, closure: {
 print("1 end")
 group.leave()
 })
 }
 
 queue.async(group: group) {
 group.enter()
 print("2 start")
 networkRequest(sleepTime:4, closure: {
 print("2 end")
 group.leave()
 })
 }
 
 queue.async(group: group) {
 group.enter()
 print("3 start")
 networkRequest(sleepTime:6, closure: {
 print("3 end")
 group.leave()
 })
 }
 
 queue.async(group: group) {
 group.enter()
 print("4 start")
 networkRequest(sleepTime:1, closure: {
 print("4 end")
 group.leave()
 })
 }
 
 group.notify(queue: queue) { // 所有组完成后回调
 print("all done")
 }
 }
 
 gcd_group_enter_leave()
 */

let workerQueue = DispatchQueue(label: "com.raywenderlich.worker", attributes: .concurrent)
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

//: ## Creating a group
print("=== Group of sync tasks ===\n")
// TODO: Create slowAddGroup

let slowAddGroup = DispatchGroup()

//: ## Dispatching to a group
// TODO: Loop to add slowAdd tasks to group

for inValue in numberArray
{
    workerQueue.async(group: slowAddGroup) {
        let result = slowAdd(inValue)
        print("\(inValue) = \(result)")
    }
}

//: ## Notification of group completion
//: Will be called only when every task in the dispatch group has completed
let defaultQueue = DispatchQueue.global()
// TODO: Call notify method

slowAddGroup.notify(queue: defaultQueue){
    print("Done")
}

//: ## Waiting for a group to complete
//: __DANGER__ This is synchronous and can block:
//:
//: This is a synchronous call on the __current__ queue, so will block it. You cannot have anything in the group that wants to use the current queue otherwise you'll deadlock.
// TODO: Call wait method

print("wait before......")
slowAddGroup.wait(timeout: DispatchTime.distantFuture)
print("wait after......")

//: ## Wrapping an existing Async API
//: All well and good for new APIs, but there are lots of async APIs that don't have group parameters. What can you do with them, so the group knows when they're *really* finished?
//:
//: Remember from the previous video, the `slowAdd` function we wrapped as an asynchronous function?

func asyncAdd(_ input: (Int, Int), runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (Int, Error?) -> ()) {
    runQueue.async {
        var error: Error?
        error = .none
        let result = slowAdd(input)
        completionQueue.async { completion(result, error) }
    }
}

//: Wrap `asyncAdd` function
// TODO: Create asyncAdd_Group

func asyncAdd_Group(_ input: (Int, Int), runQueue: DispatchQueue, completionQueue: DispatchQueue, group: DispatchGroup, completion: @escaping (Int, Error?) -> ()) {
    group.enter()
    asyncAdd(input, runQueue: runQueue, completionQueue: completionQueue) { (result, error) in
        completion(result, error)
        group.leave()
    }
}



//print("\n=== Group of async tasks ===\n")
let wrappedGroup = DispatchGroup()

for pair in numberArray {
    asyncAdd_Group(pair, runQueue: workerQueue, completionQueue: defaultQueue, group: wrappedGroup, completion: { (result, error) in
        print("\(pair) = \(result)")
    })
}

// TODO: Notify of completion

wrappedGroup.notify(queue: defaultQueue) { 
    print("Async Done!")
}
