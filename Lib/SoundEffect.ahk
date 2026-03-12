/**
 * 用SoundBeep()实现的简单音效
 * * 默认异步播放，不会阻塞脚本线程
 */
class SoundEffect {
    static _soundLibrary := Map(
        "Active",   [[600, 100], [800, 100]],
        "Deactive", [[800, 100], [600, 100]]
    )

    /**
     * 内部逻辑：播放音效（阻塞）
     * @param soundName 音效名称
     */
    static _PlaySoundCore(soundName) {
        for item in this._soundLibrary[soundName] {
            SoundBeep(item[1], item[2])
        }
    }

    /**
     * 内部逻辑：播放音效
     * @param soundName 音效名称
     * @param async 是否异步播放
     */
    static _PlaySound(soundName, async) {
        if async {
            SetTimer(() => this._PlaySoundCore(soundName), -1)
        } else {
            this._PlaySoundCore(soundName)
        }
    }

    /**
     * 播放激活音效
     * @param async 是否异步播放（默认 true）
     */
    static PlaySoundActive(async := true) => this._PlaySound("Active", async)

    /**
     * 播放禁用音效
     * @param async 是否异步播放（默认 true）
     */
    static PlaySoundDeactive(async := true) => this._PlaySound("Deactive", async)
}