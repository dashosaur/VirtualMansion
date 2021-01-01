import ArgumentParser
import Foundation
import Sword
import VirtualMansionLib

struct VirtualMansion: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "If you have to ask you're not invited.",
                                                    subcommands: [])
    
    @Option(help: "The path to the database.")
    var db: String?
    
    @Option(help: "The token for The Mirror bot.")
    var mirrorToken: String?
    
    @Option(help: "The token for Award Lord bot.")
    var awardToken: String?
    
    @Option(help: "The token for Force of Nature bot.")
    var forceToken: String?
    
    @Flag(help: "Enable verbose print statements.")
    var debug = false
    
    func validate() throws {
        guard mirrorToken != nil || awardToken != nil || forceToken != nil else {
            throw ValidationError("No token provided.")
        }
        guard [mirrorToken, awardToken, forceToken].filter({ $0 != nil }).count == 1 else {
            throw ValidationError("Only one token can be provided at a time.")
        }
    }
    
    func run() throws {
        verboseLoggingEnabled = debug
        
        let database = try Database(path: db)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        log("\nYou have entered the mansion. The clock reads \(dateFormatter.string(from: Date())).")
        
        let token: String
        if let mirrorToken = mirrorToken {
            token = mirrorToken
        } else if let awardToken = awardToken {
            token = awardToken
        } else if let forceToken = forceToken {
            token = forceToken
        } else {
            fatalError()
        }
        
        let sword = Sword(token: token)
        sword.getGuild(.publicHouse, rest: true) { (guild, error) in
            guard let guild = guild else {
                fatalError("Could not find public house guild: \(error.debugDescription)")
            }
            
            let bot: Bot
            if mirrorToken != nil {
                bot = TheMirror(sword: sword, guild: guild, database: database)
            } else if awardToken != nil {
                bot = AwardLord(sword: sword, guild: guild, database: database)
            } else if forceToken != nil {
                bot = ForceOfNature(sword: sword, guild: guild, database: database)
            } else {
                fatalError()
            }
            
            log("\(bot.botName) is here at your service.\n")
            
            bot.run()
        }
        sword.connect()
    }
}

VirtualMansion.main()
