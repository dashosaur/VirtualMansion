import ArgumentParser
import VirtualMansionLib
import Sword

struct VirtualMansion: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "If you have to ask you're not invited.",
                                                    subcommands: [])
    
    @Option(help: "The token for The Mirror bot.")
    var mirrorToken: String?
    
    @Option(help: "The token for Award bot.")
    var awardToken: String?
    
    @Flag(help: "Enable verbose print statements.")
    var verbose = false
    
    func validate() throws {
        guard mirrorToken != nil || awardToken != nil else {
            throw ValidationError("No token provided.")
        }
        guard mirrorToken == nil || awardToken == nil else {
            throw ValidationError("Only one token can be provided at a time.")
        }
    }
    
    func run() {
        verboseLoggingEnabled = verbose
        
        log("You have entered the mansion.")
        
        let token: String
        if let mirrorToken = mirrorToken {
            token = mirrorToken
        } else if let awardToken = awardToken {
            token = awardToken
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
                bot = TheMirror(sword: sword, guild: guild)
            } else if awardToken != nil {
                bot = AwardLord(sword: sword, guild: guild)
            } else {
                fatalError()
            }
            
            bot.run()
        }
        sword.connect()
    }
}

VirtualMansion.main()
