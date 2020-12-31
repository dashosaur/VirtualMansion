import ArgumentParser

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
        print("You have entered the mansion.")
        
        var bot: Bot
        var token: String
        if let mirrorToken = mirrorToken {
            bot = TheMirror()
            token = mirrorToken
        } else if let awardToken = awardToken {
            bot = AwardLord()
            token = awardToken
        } else {
            fatalError()
        }
        
        bot.run(token: token)
    }
}

VirtualMansion.main()

protocol Bot {
    func run(token: String)
}
