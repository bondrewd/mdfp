const std = @import("std");
const testing = std.testing;

const TokenKind = enum {
    bracket_left,
    bracket_right,
    semicolon,
    hash,
    string,
    integer,
    float,
    directive,
    space,
};

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
