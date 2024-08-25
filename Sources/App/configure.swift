import MySQLKit
import Vapor

// configures your application
public func configure(_ app: Application) async throws {

  let configuration = MySQLConfiguration(
    hostname: Environment.get("MYSQL_HOSTNAME") ?? "",
    port: Environment.get("MYSQL_PORT").flatMap(Int.init) ?? 3306,
    username: Environment.get("MYSQL_USERNAME") ?? "",
    password: Environment.get("MYSQL_PASSWORD") ?? "",
    database: Environment.get("MYSQL_DATABASE") ?? "",
    tlsConfiguration: .makePreSharedKeyConfiguration()
  )

  let eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
  defer { try! eventLoopGroup.syncShutdownGracefully() }

  let pools = EventLoopGroupConnectionPool(
    source: MySQLConnectionSource(configuration: configuration),
    on: eventLoopGroup
  )

  defer { pools.shutdown() }

  app.databases.use(.mysql(configuration: configuration), as: .mysql)
  
  try routes(app)
}
