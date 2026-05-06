/**
 * Windows API 鼠标控制
 ** 基于 Windows API 的鼠标控制功能，用于一些游戏中传统鼠标移动方式失效的情况（如 ETS2）
 ** 注意光标的坐标是由类内部自行维护的，这是因为一些游戏接管输入流并维护独立的逻辑光标，因此 MouseGetPos() 并不能获取到真正的游戏内光标位置，必须由类自行跟踪坐标变化
 */
class DllMouse {
    static _x := unset
    static _y := unset

    /**
     * 将光标移动到 ( 0 , 0 ) 并初始化坐标
     */
    static Init() {
        DllCall("mouse_event", "UInt", 0x0001, "Int", A_ScreenWidth * -1, "Int", A_ScreenHeight * -1, "UInt", 0, "UPtr", 0)
        this._x := 0
        this._y := 0
    }

    /**
     * 销毁坐标信息，使其变为未设置状态，不会实际移动光标
     */
    static Clear() {
        this._x := unset
        this._y := unset
    }

    /**
     * 获取当前光标逻辑位置
     * @param outX 接收 X 坐标的变量引用
     * @param outY 接收 Y 坐标的变量引用
     */
    static GetPos(&outX, &outY) {
        if !HasProp(this, "_x") || !HasProp(this, "_y") {
            throw UnsetError("DllMouse 尚未初始化。必须先调用 Init() 或 Move()")
        }
        outX := this._x
        outY := this._y
    }

    /**
     * 移动光标
     * @param x 目标坐标或增量
     * @param y 目标坐标或增量
     * @param relative 是否执行相对移动（默认 false）
     */
    static Move(x, y, relative:= false) {
        if !HasProp(this, "_x") || !HasProp(this, "_y") {
            this.Init()
            Sleep(1) ; 确保系统处理完光标移动
        }
        if relative {
            DllCall("mouse_event", "UInt", 0x0001, "Int", x, "Int", y, "UInt", 0, "UPtr", 0)
            ; 防止越界
            this._x := Max(0, Min(A_ScreenWidth, this._x + x))
            this._y := Max(0, Min(A_ScreenHeight, this._y + y))
        } else {
            if x < 0 || x > A_ScreenWidth || y < 0 || y > A_ScreenHeight {
                throw ValueError("目标坐标 (" x "," y ") 超出主屏范围 (0,0) - (" A_ScreenWidth "," A_ScreenHeight ")")
            }
            dx := x - this._x
            dy := y - this._y
            DllCall("mouse_event", "UInt", 0x0001, "Int", dx, "Int", dy, "UInt", 0, "UPtr", 0)
            this._x := x
            this._y := y
        }
        Sleep(1)
    }
}