import cpp.ConstCharStar;
import cpp.Star;

@:keep
@:structAccess
@:unreflective
@:include('vita2d.h')
extern class Vita2D
{
    @:native('vita2d_init')
    static function init() : Int;

    @:native('vita2d_wait_rendering_done')
    static function waitForRendering() : Void;

    @:native('vita2d_fini')
    static function finish() : Int;

    @:native('vita2d_clear_screen')
    static function clearScreen() : Void;

    @:native('vita2d_swap_buffers')
    static function swapBuffers() : Void;

    @:native('vita2d_set_clear_color')
    static function setClearColour(_colour : Int) : Void;

    @:native('vita2d_get_clear_color')
    static function getClearColour() : Int;

    @:native('vita2d_start_drawing')
    static function startDrawing() : Void;

    @:native('vita2d_end_drawing')
    static function endDrawing() : Void;

    @:native('vita2d_load_default_pvf')
    static function loadDefaultPvf() : Star<Vita2DPVF>;

    @:native('vita2d_load_default_pgf')
    static function loadDefaultPgf() : Star<Vita2DPGF>;

    @:native('vita2d_pvf_draw_text')
    static function pvfDrawText(_font : Star<Vita2DPVF>, _x : Int, _y : Int, _colour : Int, _scale : Float, _text : ConstCharStar) : Int;

    @:native('vita2d_pgf_draw_text')
    static function pgfDrawText(_font : Star<Vita2DPGF>, _x : Int, _y : Int, _colour : Int, _scale : Float, _text : ConstCharStar) : Int;

    @:native('vita2d_draw_rectangle')
    static function drawRectangle(_x : Float, _y : Float, _w : Float, _h : Float, _colour : Int) : Void;
}

@:keep
@:structAccess
@:unreflective
@:include('vita2d.h')
@:native('vita2d_pvf')
extern class Vita2DPVF
{
    //
}

@:keep
@:structAccess
@:unreflective
@:include('vita2d.h')
@:native('vita2d_pgf')
extern class Vita2DPGF
{
    //
}
