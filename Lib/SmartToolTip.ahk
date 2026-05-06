/**
 * 智能提示
 * * 跟随鼠标，且仅在内容或位置变化时更新，防止闪烁
 */
class SmartToolTip {
    static _text := ""
    static _which := 1
    static _lastTip := ""
    static _lastX := 0
    static _lastY := 0
    static _period := 100
    static _callback := ""

    /**
     * 内部逻辑：检查位置和内容是否有变化
     */
    static _Tick() {
        MouseGetPos(&currX, &currY)
        ; 只有当文字变了，或者鼠标位移了，才触发 ToolTip 更新
        if this._text != this._lastTip || currX != this._lastX || currY != this._lastY {
            this._lastTip := this._text
            this._lastX := currX
            this._lastY := currY
            ToolTip(this._text, , , this._which)
        }
    }

    /**
     * 显示提示框
     * @param text 提示内容
     * @param period 检查间隔 (默认 100ms)
     * @param which 要使用哪个ToolTip，请指定一个介于1-20之间的整数，默认为1。通常情况下无需修改，除非你希望屏幕上有多个ToolTip能够同时显示
     */
    static Show(text := unset, period := unset, which := unset) {
        if IsSet(text) {
            this._text := text
        }
        if IsSet(period) {
            this._period := period
        }
        if IsSet(which) && which != this._which {
            this.Hide()
            this._which := which
            this._lastTip := ""
        }
        
        ; 惰性初始化 callback
        if !this._callback {
            this._callback := ObjBindMethod(this, "_Tick")
        }
        
        ; 立刻调用一次 _Tick()，避免延迟
        this._Tick()
        SetTimer(this._callback, this._period)
    }

    /**
     * 隐藏提示（停止定时器并清除显示）
     */
    static Hide() {
        if this._callback {
            SetTimer(this._callback, 0)
        }
        ToolTip(, , , this._which)
        this._lastTip := ""
    }

    /**
     * 更新提示文字
     * @param newText 新的提示内容
     */
    static Update(newText) {
        this._text := newText
    }
}