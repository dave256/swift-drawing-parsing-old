//
//  Parsing.swift
//
//
//  Created by David M Reed on 12/14/23.
//

import CoreGraphics
import Drawing
import Parsing

// MARK: CGPoint

public extension CGPoint {

    /// two numbers (can be int or double) separated by one or more spaces
    static var parser = ParsePrint(input: Substring.self, .memberwise(CGPoint.init(x:y:))) {
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// array of CGPoint - each point on its own line
    static var oneOrMoreParser = ParsePrint(input: Substring.self) {
        Many(1...) {
            CGPoint.parser
        } separator: {
            // each point must be on its own line
            "\n"
        } terminator: {
            // must have a \n after last point
            "\n".utf8
        }
    }
}

// MARK: Transform

public extension Transform {

    // a transform is one of the rotate, scale, or translate transformation
    static var parser = ParsePrint(input: Substring.self) {
        OneOf {
            rotateParsePrint
            scaleParsePrint
            translateParsePrint
        }
    }

    /// zero or more transformations separated by at least one white space character (prints a newline between them)
    /// won't consume whitespace if there are no transforms
    static var zeroOrMoreParser = ParsePrint(input: Substring.self) {
        Many {
            Transform.parser
        } separator: {
            Whitespace(1, .vertical)
        }
    }

    /// r followed by one or more spaces/tabs, followed by the angle in degrees
    static var rotateParsePrint = ParsePrint(input: Substring.self, RotateConversion()) {
        "r"
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// s followed by one ore more spaces followed by a number for the x scale, followed by one ore more spaces followed by the number for the y scale
    static var scaleParsePrint = ParsePrint(input: Substring.self, ScaleConversion()) {
        "s"
        Whitespace(1..., .horizontal)
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// t followed by one ore more spaces followed by a number for the x translation, followed by one ore more spaces followed by the number for the y translation
    static var translateParsePrint = ParsePrint(input: Substring.self, TranslateConversion()) {
        "t"
        Whitespace(1..., .horizontal)
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// Conversion necessary for parsing
    struct RotateConversion: Conversion {
        public func apply(_ angle: Double) -> Transform {
            // make a Transform from the angle
            Transform.r(angle)
        }

        public func unapply(_ transform: Transform) throws -> Double {
            struct ParseError: Error {}
            switch transform {
                    // handle the rotation case
                case let .r(angle):
                    return angle
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }

    /// Conversion necessary for parsing
    struct ScaleConversion: Conversion {
        public func apply(_ scales: (Double, Double)) -> Transform {
            // make a Transform with the scale values
            Transform.s(scales.0, scales.1)
        }

        public func unapply(_ transform: Transform) throws -> (Double, Double) {
            struct ParseError: Error {}
            switch transform {
                    // handle the scale case
                case let .s(sx, sy):
                    return (sx, sy)
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }

    /// Conversion necessary for parsing
    struct TranslateConversion: Conversion {
        public func apply(_ translates: (Double, Double)) -> Transform {
            // make a Transform with the translation values
            Transform.t(translates.0, translates.1)
        }

        public func unapply(_ transform: Transform) throws -> (Double, Double) {
            struct ParseError: Error {}
            switch transform {
                    // handle the translation case case
                case let .t(tx, ty):
                    return (tx, ty)
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }
}

// MARK: DrawStyle

public extension DrawStyle {
    /// "path", "closed", or "filled" followed by one or more spaces/tabs followed by a color
    static let parser = ParsePrint(input: Substring.self, .memberwise(DrawStyle.init)) {
        Style.parser()
        Whitespace(1..., .horizontal)
        Color.parser()
    }
}

// MARK: UnitSquare

public extension UnitSquare {
    /// "unit square" followed by a blank line followed by a DrawStyle (such as "filled red") followed by a blank line followed by Transforms (such as "r 45.0" or "s 2.5 3.5" or "t 1.5 2.5")
    static let parser = ParsePrint(input: Substring.self, .memberwise(UnitSquare.init)) {
        "unit square"
        Whitespace(0..., .horizontal)
        PrefixUpTo("\n").map(.string)
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(0..., .vertical).printing("\n".utf8)
        Transform.zeroOrMoreParser
    }
}

// MARK: UnitCircle

public extension UnitCircle {
    /// "unit circle" followed by a blank line followed by a DrawStyle (such as "filled red") followed by a blank line followed by Transforms (such as "r 45.0" or "s 2.5 3.5" or "t 1.5 2.5")
    static let parser = ParsePrint(input: Substring.self, .memberwise(UnitCircle.init)) {
        "unit circle"
        Whitespace(0..., .horizontal)
        PrefixUpTo("\n").map(.string)
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(0..., .vertical).printing("\n".utf8)
        Transform.zeroOrMoreParser
    }
}
