import XCTest
@testable import Drawing
@testable import DrawingParsing

final class InternalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOneSquare() throws {
        let input: Substring = """
unit square
filled red
s 8 9
"""
        let shapes = try DrawableShape.zeroOrMoreParser.parse(input)
        let expected = [DrawableShape.unitSquare(.init(drawStyle: .init(style: .filled, color: .red), transforms: [.s(8, 9)]))]
        XCTAssertEqual(shapes, expected)
    }

    func testOneCircle() throws {
        let input: Substring = """
unit circle
filled red
s 8.0 9.0
"""
        let shapes = try DrawableShape.zeroOrMoreParser.parse(input)
        let expected = [DrawableShape.unitCircle(.init(drawStyle: .init(style: .filled, color: .red), transforms: [.s(8, 9)]))]
        XCTAssertEqual(shapes, expected)
    }

    func testMultipleShapes() throws {

        let s = [
            DrawableShape.unitSquare(UnitSquare(drawStyle: .init(style: .filled, color: .red), transforms: [])),
            DrawableShape.unitCircle(UnitCircle(drawStyle: .init(style: .closed, color: .green), transforms: [.s(8, 9)])),
            DrawableShape.unitSquare(UnitSquare(drawStyle: .init(style: .closed, color: .green), transforms: [.r(45)])),
        ]
        let output = try DrawableShape.zeroOrMoreParser.print(s)
        print("output")
        print(output)
        print("end")
        let input: Substring = """
unit square
filled red

unit circle
closed green
s 8.0 9.0

unit square
closed green
r 45.0
"""
        print("input")
        print(input)
        print("end")
        let shapes = try DrawableShape.zeroOrMoreParser.parse(input)
        XCTAssertEqual(shapes, s)
        //XCTAssertEqual(input, output)
        dump(shapes)

    }

    func testMultipleShapesNoTransforms() throws {

        let s = [
            DrawableShape.unitSquare(UnitSquare(drawStyle: .init(style: .filled, color: .red), transforms: [])),
            DrawableShape.unitCircle(UnitCircle(drawStyle: .init(style: .closed, color: .green), transforms: [])),
            DrawableShape.unitSquare(UnitSquare(drawStyle: .init(style: .closed, color: .green), transforms: [])),
        ]
        let output = try DrawableShape.zeroOrMoreParser.print(s)
        print("output")
        print(output)
        print("end")
        let input: Substring = """
unit square
filled red

unit circle
closed green

unit square
closed green
"""
        print("input")
        print(input)
        print("end")
        let shapes = try DrawableShape.zeroOrMoreParser.parse(input)
        XCTAssertEqual(shapes, s)
        //XCTAssertEqual(input, output)
        dump(shapes)

    }

    func testShapeGroup() throws {
        let input: Substring = """
group Name for the Group
transforms
s 2.0 3.0
r 45

unit square
filled red

unit circle
filled green
t 1 3

group
transforms

unit circle
filled red
s 1 1
t 2 3

unit square
filled red
s 3.0 5.0
t 6 7

"""

        let g = try DrawableShapeGroup.zeroOrMoreParser.parse(input)
    }


}
