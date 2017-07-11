//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

/*
 *Passing zero for the value is useful for when two threads need to reconcile（ 使一致） the completion of a particular event. Passing a value greater than zero is useful for managing a finite pool of resources, where the pool size is equal to the value.
 */
let semaphore = DispatchSemaphore(value: 1)

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)


func asyncPrint(queue: DispatchQueue, symbol: String) {
    queue.async {
        print("\(symbol) waiting")
        semaphore.wait()  //请求资源
        
        for i in 0...10 {
            print(symbol, i)
        }
        
        print("\(symbol) signal")
        semaphore.signal() //释放资源
    }
}

asyncPrint(queue: higherPriority, symbol: "🔴")
asyncPrint(queue: lowerPriority, symbol: "🔵")


PlaygroundPage.current.needsIndefiniteExecution = true