// Modules
const std = @import("std");
const mem = std.mem;
const testing = std.testing;
// Types
const Allocator = mem.Allocator;
const ArrayList = std.ArrayList;
// Functions
const copy = mem.copy;

const TokenKind = enum {
    semicolon,
    directive,
    string,
    integer,
    float,
    space,
};

const Token = struct {
    kind: TokenKind = undefined,
    data: []u8 = undefined,
    //line_number: usize = undefined,
    //line_offset: usize = undefined,
};

pub fn endToken(token_list: *ArrayList(Token), token: *Token, str: []u8) void {
    try token_list.append(.{
        .kind = token.kind,
        .data = str.toOwnedSlice(),
    });

    token = .{
        .kind = .space,
    };
}

pub fn tokenizeReader(reader: anytype, allocator: Allocator) ![]Token {
    // Token list initialization
    var token_list = ArrayList(Token).init(allocator);
    defer token_list.deinit();

    // String
    var str = ArrayList(u8).init(allocator);
    defer str.deinit();

    // Token tracker
    var current_token = Token{};

    // Tokenize
    while (true) {
        // Get character
        const c = reader.readByte() catch break;

        // Parse character
        switch (c) {
            ' ' => switch (current_token.kind) {
                .space => continue,
                else => endToken(token_list, current_token, str.toOwnedSlice()),
            },
            '[' => switch (current_token.kind) {
                else => std.debug.print("Error!\n", .{}),
            },
            else => std.debug.print("{c}", .{c}),
        }
    }

    return token_list.toOwnedSlice();
}

pub fn displayErrorUnexpectedToken(token_data: []const u8) !void {
    // Get writer
    const stdout = std.io.getStdOut().writer();

    const str1 = "Error: ";
    const str2 = "Expected ";
    const str3 = "directive";
    const str4 = ", found '";
    const str5 = "{s}";
    const str6 = "'";
    const tmp1 = str1 ++ str2 ++ str3 ++ str4 ++ str5 ++ str6;

    try stdout.print(tmp1, .{token_data});
}

test "tokenizeReader" {
    const content =
        \\[ foo ]
        \\a
        \\b
        \\c
    ;

    var reader = std.io.fixedBufferStream(content[0..]).reader();
    _ = try tokenizeReader(reader, testing.allocator);
}
