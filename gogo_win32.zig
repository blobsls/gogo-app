const std = @import("std");
const windows = std.os.windows;
const WINAPI = windows.WINAPI;

pub const GogoWin32 = struct {
    // Window handle
    hwnd: windows.HWND,

    // Initialize Gogo for Win32
    pub fn init() !GogoWin32 {
        // Register window class
        const wc = windows.WNDCLASSEXW{
            .lpfnWndProc = windowProc,
            .hInstance = @ptrCast(windows.HINSTANCE, windows.kernel32.GetModuleHandleW(null)),
            .lpszClassName = L"GogoWin32Class",
            .style = windows.CS_HREDRAW | windows.CS_VREDRAW,
            .hCursor = @ptrCast(windows.HCURSOR, windows.user32.LoadCursorW(null, windows.IDC_ARROW)),
            .hbrBackground = @ptrCast(windows.HBRUSH, windows.COLOR_WINDOW + 1),
            .cbSize = @sizeOf(windows.WNDCLASSEXW),
        };

        _ = try windows.user32.RegisterClassExW(&wc);

        // Create window
        const hwnd = try windows.user32.CreateWindowExW(
            0,
            wc.lpszClassName,
            L"Gogo Win32",
            windows.WS_OVERLAPPEDWINDOW,
            windows.CW_USEDEFAULT,
            windows.CW_USEDEFAULT,
            800,
            600,
            null,
            null,
            wc.hInstance,
            null,
        );

        return GogoWin32{ .hwnd = hwnd };
    }

    // Window procedure
    fn windowProc(
        hwnd: windows.HWND,
        uMsg: windows.UINT,
        wParam: windows.WPARAM,
        lParam: windows.LPARAM,
    ) callconv(WINAPI) windows.LRESULT {
        switch (uMsg) {
            windows.WM_DESTROY => {
                windows.user32.PostQuitMessage(0);
                return 0;
            },
            else => return windows.user32.DefWindowProcW(hwnd, uMsg, wParam, lParam),
        }
    }

    // Run message loop
    pub fn run(self: *GogoWin32) !void {
        var msg: windows.MSG = undefined;
        while (windows.user32.GetMessageW(&msg, null, 0, 0) != 0) {
            _ = windows.user32.TranslateMessage(&msg);
            _ = windows.user32.DispatchMessageW(&msg);
        }
    }

    // Clean up
    pub fn deinit(self: *GogoWin32) void {
        _ = windows.user32.DestroyWindow(self.hwnd);
    }
};

pub fn main() !void {
    var gogo = try GogoWin32.init();
    defer gogo.deinit();

    try gogo.run();
}
