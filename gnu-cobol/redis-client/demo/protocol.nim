import logging

type
    RedisProtocolException* = ref object of IOError

    RespKind* = enum
        rkString,
        rkError,
        rkInt,
        rkBulkStrings,
        rkArray,

    Resp* = object
        case kind*: RespKind
        of rkString:
            stringValue*: string
        of rkError:
            errorValue*: string
        of rkInt:
            intValue*: int
        of rkBulkStrings:
            bulkStrings*: seq[string]
        of rkArray: discard

let
    logger = newConsoleLogger(fmtStr="[$time] [$levelname] [protocol] ", useStderr=true)

proc parseResp*(s: string): Resp {.raises: [Exception]} =
    if s.len() == 0:
        raise newException(IOError, "Redis Procotol Error")

    case s[0]:
    of '+':
        let value = s[1 ..< s.len]
        return Resp(kind: rkString, stringValue: value)

    of '-':
        let value = s[1 ..< s.len]
        return Resp(kind: rkError, errorValue: value)

    of ':', '$', '*':
        logger.log lvlError, "RespKind not implemented yet. kind='", s[0], "'"
        raise newException(IOError, "Redis Procotol Error")

    else:
        logger.log lvlError, "Unknown RespKind. kind='", s[0], "'"
        raise newException(IOError, "Redis Procotol Error")
