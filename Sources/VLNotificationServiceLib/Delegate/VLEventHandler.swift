//
//  VLEventHandler.swift
//  
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

/// Protocol for an object that will receive SSE events.
public protocol VLEventHandler {
    /// EventSource calls this method when the stream connection has been opened.
    func onOpened()
    /// EventSource calls this method when the stream connection has been closed.
    func onClosed()
    /** EventSource calls this method when it has received a new event from the stream.

     - Parameter eventType: The type of the event.
     - Parameter messageEvent: The data for the event.
     */
    func onMessage<T: Decodable>(eventType: VLAppleNotificationType, messageEvent: T)
    /** EventSource calls this method when it has received a comment line from the stream.

     This method will be called for all exceptions that occur on the socket connection
     - Parameter error: The error received.
     */
    func onError(error: Error)
}

/// Enum values representing the states of an EventSource
public enum ConnectionState: String, Equatable {
    /// The EventSource has not been started yet.
    case notStarted
    /// The EventSource is attempting to make a connection.
    case connecting
    /// The EventSource is active and the EventSource is listening for events.
    case open
    /// The connection has been closed or has failed, and the EventSource will attempt to reconnect.
    case closed
    /// The connection has been permanently closed and will not reconnect.
    case shutdown
}

/// Error class that means the remote server returned an HTTP error.
public class UnsuccessfulResponseError: Error {
    /// The HTTP response code received
    public let responseCode: Int

    public init(responseCode: Int) {
        self.responseCode = responseCode
    }
}
