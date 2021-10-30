{.push raises: [Defect].}

import net
import logging

import protocol

const
    pingCmd = "PING\c\l"

type
    RedisClient* = object
        socket: Socket
        host: string
        port: Port

let
    logger = newConsoleLogger(fmtStr="[$time] [$levelname] [redis] ", useStderr=true)

proc newRedisClient*(): RedisClient {.raises: [OSError, Exception]} =
    result.socket = newSocket()
    logger.log lvlDebug, "socket created. fd=", cint(result.socket.getFd())

proc connect*(self: var RedisClient, host: string, port: net.Port) {.raises: [OSError, Exception]} =
    self.host = host
    self.port = port

    logger.log lvlInfo, "connecting to server... host=", host, " port=", port

    self.socket.connect host, port

    logger.log lvlInfo, "connected."

proc close*(self: RedisClient) {.raises: [Exception]} =
    logger.log lvlDebug, "closing socket... fd=", cint(self.socket.getFd())

    self.socket.close()
    
    logger.log lvlDebug, "socket closed successfully."

proc ping*(self: RedisClient): string {.raises: [OSError, TimeoutError, Exception]} =
    logger.log lvlDebug, "sending command... cmd=PING"

    self.socket.send(pingCmd)

    var line: string
    self.socket.readLine(line)

    let resp: Resp = protocol.parseResp(line)
    if resp.kind != rkString:
        raise newException(IOError, "Redis Protocol Exception")
    logger.log lvlDebug, "ping success."

    result = resp.stringValue
