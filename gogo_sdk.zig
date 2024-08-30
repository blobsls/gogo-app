
const std = @import("std");
const c = @cImport({
    @cInclude("gogo_api.h");
});

pub const GogoSDK = struct {
    initialized: bool,

    pub fn init() !GogoSDK {
        if (c.gogo_initialize() != 0) {
            return error.InitializationFailed;
        }
        return GogoSDK{ .initialized = true };
    }

    pub fn deinit(self: *GogoSDK) void {
        if (self.initialized) {
            c.gogo_cleanup();
            self.initialized = false;
        }
    }

    pub fn makeApiCall(self: *const GogoSDK, endpoint: []const u8, params: []const u8) ![]const u8 {
        if (!self.initialized) {
            return error.SDKNotInitialized;
        }

        const result = c.gogo_api_call(endpoint.ptr, params.ptr);
        if (result == null) {
            return error.ApiCallFailed;
        }
        defer c.gogo_free_result(result);

        return std.mem.sliceTo(result, 0);
    }
};