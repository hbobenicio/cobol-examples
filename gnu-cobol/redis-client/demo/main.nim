import system
import net
import logging

import ./redis

const
    host = "localhost"
    port = Port(6379)

proc main() =
    let logger = newConsoleLogger(fmtStr="[$time] [$levelname] ", useStderr=true)
    logging.addHandler logger

    var redisClient = newRedisClient()
    redisClient.connect host, port
    defer: redisClient.close()

    echo "> PING"
    let pong = redisClient.ping()
    echo "< ", pong

when isMainModule:
    main()