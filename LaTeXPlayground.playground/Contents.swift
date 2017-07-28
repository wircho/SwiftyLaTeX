//: Playground - noun: a place where people can play

infix operator ÷: MultiplicationPrecedence

struct LaTeX {
    let code: String
    let precedence: Precedence
    let height: Height
    init(_ code: String, precedence: Precedence = .item, height: Height = .single) {
        self.code = code
        self.precedence = precedence
        self.height = height
    }
}

extension LaTeX: CustomStringConvertible {
    var description: String { return "$" + code + "$" }
}

extension LaTeX {
    init(_ i: Int) {
        self.init(i.description)
    }
}

extension LaTeX {
    enum Precedence: Int {
        case item = 1000
        case prefixed = 900
        case multiplicative = 800
        case additive = 600
    }
    
    enum Height {
        case single
        case multiple
    }
}

extension LaTeX.Precedence: Comparable {
    static func <(lhs: LaTeX.Precedence, rhs: LaTeX.Precedence) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func <=(lhs: LaTeX.Precedence, rhs: LaTeX.Precedence) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func ==(lhs: LaTeX.Precedence, rhs: LaTeX.Precedence) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func >=(lhs: LaTeX.Precedence, rhs: LaTeX.Precedence) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
    
    static func >(lhs: LaTeX.Precedence, rhs: LaTeX.Precedence) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

func max(_ heights: LaTeX.Height ...) -> LaTeX.Height {
    for height in heights {
        guard height == .single else { return .multiple }
    }
    return .single
}

extension LaTeX {
    var groupedCode: String {
        switch height {
        case .single: return "(" + code + ")"
        case .multiple: return "\\left(" + "code" + "\\right)"
        }
    }
    
    func code(for precedence: Precedence, weak: Bool = false) -> String {
        return self.precedence < precedence || (self.precedence == precedence && weak) ? groupedCode : code
    }
}

extension LaTeX {
    static func +(lhs: LaTeX, rhs: LaTeX) -> LaTeX {
        return LaTeX(lhs.code(for: .additive) + "+" + rhs.code(for: .additive), precedence: .additive, height: max(lhs.height, rhs.height))
    }
    
    static func -(lhs: LaTeX, rhs: LaTeX) -> LaTeX {
        return LaTeX(lhs.code(for: .additive) + "-" + rhs.code(for: .additive, weak: true), precedence: .additive, height: max(lhs.height, rhs.height))
    }
    
    static prefix func -(latex: LaTeX) -> LaTeX {
        return LaTeX(latex.code(for: .prefixed), precedence: .prefixed, height: latex.height)
    }
    
    static func *(lhs: LaTeX, rhs: LaTeX) -> LaTeX {
        return LaTeX(lhs.code(for: .multiplicative) + " \\times " + rhs.code(for: .multiplicative), precedence: .multiplicative, height: max(lhs.height, rhs.height))
    }
    
    static func /(lhs: LaTeX, rhs: LaTeX) -> LaTeX {
        return LaTeX(lhs.code(for: .multiplicative) + "/" + rhs.code(for: .multiplicative), precedence: .multiplicative, height: max(lhs.height, rhs.height))
    }
    
    static func ÷(lhs: LaTeX, rhs: LaTeX) -> LaTeX {
        return LaTeX("\\frac{" + lhs.code + "}{" + rhs.code + "}", precedence: .item, height: .multiple)
    }
}

let x = LaTeX("x")
let y = LaTeX("y")
let z = LaTeX("z")

let xy = x + y
let w = LaTeX(2) - LaTeX(1)
xy * z ÷ w



