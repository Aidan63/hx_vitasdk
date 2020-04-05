import haxe.io.Bytes;
import sys.thread.Thread;
import haxe.Timer;

class Main {
	static function main() {
		SceCtrl.setSamplingMode(Analog);

		// Thread.create(() -> {
		// 	var n1 = 2;
		// 	var n2 = 5;
		// 	var n3 = n1 * n2;

		// 	SceClib.printf('2 * 5 = $n3\r\n');
		// });

		Vita2D.init();
		Vita2D.setClearColour(rgba8(0x40, 0x40, 0x40, 0xFF));

		final data = SceCtrlData.create();
		final pgf  = Vita2D.loadDefaultPgf();

		var x = 512;
		var y = 512;
		var a = false;

		while (true) {
			SceCtrl.peekBufferPositive(0, cpp.Native.addressOf(data), 1);
			if (data.buttons & SceCtrlButtons.Cross == SceCtrlButtons.Cross) {
				break;
			}
			if (data.buttons & SceCtrlButtons.Square == SceCtrlButtons.Square) {
				a = !a;
			}

			Vita2D.startDrawing();
			Vita2D.clearScreen();

			Vita2D.pgfDrawText(pgf, 32,  32, rgba8(0, 255, 0, 255), 1, 'HxCPP GC Stats');
			Vita2D.pgfDrawText(pgf, 30,  48, rgba8(0, 255, 0, 255), 1, '    Estimated memory needed    : ${ cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_CURRENT) }');
			Vita2D.pgfDrawText(pgf, 30,  64, rgba8(0, 255, 0, 255), 1, '    Memory allocated for use   : ${ cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_RESERVED) }');
			Vita2D.pgfDrawText(pgf, 30,  80, rgba8(0, 255, 0, 255), 1, '    Memory in use              : ${ cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_USAGE) }');
			Vita2D.pgfDrawText(pgf, 30,  96, rgba8(0, 255, 0, 255), 1, '    Pool size for large allocs : ${ cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_LARGE) }');
			Vita2D.pgfDrawText(pgf, 30, 112, rgba8(0, 255, 0, 255), 1, '    Doing random allocations   : ${ a ? 'yes' : 'no' }');

			if (data.buttons & SceCtrlButtons.Left  == SceCtrlButtons.Left) x -= 8;
			if (data.buttons & SceCtrlButtons.Right == SceCtrlButtons.Right) x += 8;
			if (data.buttons & SceCtrlButtons.Up    == SceCtrlButtons.Up) y -= 8;
			if (data.buttons & SceCtrlButtons.Down  == SceCtrlButtons.Down) y += 8;

			// Do some random allocations to see changes in GC usage
			if (a) {
				final bytes = Bytes.alloc(Std.int(Std.random(1000000) + 1));
				bytes.set(0, 1);
			}

			Vita2D.drawRectangle(x - 16, y - 16, 32, 32, rgba8(0, 0, 255, 255));

			Vita2D.endDrawing();
			Vita2D.swapBuffers();
		}

		// SceClib.printf('goodbye after ${ Timer.stamp() } seconds\r\n');
		SceKernel.exitProcess(0);
	}

	static function rgba8(_r, _g, _b, _a)
		return (((_a & 0xFF) << 24) | ((_b & 0xFF) << 16) | ((_g & 0xFF) << 8) | ((_r & 0xFF) << 0));
}

@:keep
@:structAccess
@:include('psp2/kernel/clib.h')
extern class SceClib
{
	@:native('sceClibPrintf')
	static function printf(_fmt : cpp.ConstCharStar) : Int;
}

@:keep
@:structAccess
@:include('psp2/kernel/processmgr.h')
extern class SceKernel
{
	@:native('sceKernelExitProcess')
	static function exitProcess(_res : Int) : Int;
}

@:keep
@:structAccess
@:include('psp2/ctrl.h')
extern class SceCtrl
{
	@:native('sceCtrlPeekBufferPositive')
	static function peekBufferPositive(_port : Int, _pad_data : cpp.Star<SceCtrlData>, _count : Int) : Int;

	@:native('sceCtrlSetSamplingMode')
	static function setSamplingMode(_mode : SceCtrlPadInputMode) : Int;
}

@:keep
@:structAccess
@:include('psp2/ctrl.h')
@:native('SceCtrlData')
extern class SceCtrlData
{
	@:native('SceCtrlData')
	static function create() : SceCtrlData;

	var buttons : cpp.UInt32;

	var circle : cpp.UInt8;
	
	var cross : cpp.UInt8;

	var down : cpp.UInt8;

	var l1 : cpp.UInt8;

	var left : cpp.UInt8;

	var lt : cpp.UInt8;
	
	var lx : cpp.UInt8;

	var ly : cpp.UInt8;

	var r1 : cpp.UInt8;

	var right : cpp.UInt8;

	var rt : cpp.UInt8;

	var rx : cpp.UInt8;

	var ry : cpp.UInt8;

	var square : cpp.UInt8;

	var timeStamp : cpp.UInt64;

	var triangle : cpp.UInt64;

	var up : cpp.UInt64;
}

@:unreflective
@:native('SceCtrlPadInputMode')
extern class SceCtrlPadInputModeImpl {}

@:unreflective
extern enum abstract SceCtrlPadInputMode(SceCtrlPadInputModeImpl)
{
	@:native('SCE_CTRL_MODE_DIGITAL') var Digital;
	@:native('SCE_CTRL_MODE_ANALOG') var Analog;
	@:native('SCE_CTRL_MODE_ANALOG_WIDE') var AnalogWide;
}

enum abstract SceCtrlButtons(cpp.UInt32) to cpp.UInt32
{
	var Select = 0x00000001;
	var L3 = 0x00000002;
	var R3 = 0x00000004;
	var Start = 0x00000008;
	var Up = 0x00000010;
	var Right = 0x00000020;
	var Down = 0x00000040;
	var Left = 0x00000080;
	var LTrigger = 0x00000100;
	var L2 = 0x00000100;
	var RTrigger = 0x00000200;
	var R2 = 0x00000200;
	var L1 = 0x00000400;
	var R1 = 0x00000800;
	var Triangle = 0x00001000;
	var Circle = 0x00002000;
	var Cross = 0x00004000;
	var Square = 0x00008000;
	var Intercepted = 0x00010000;
	var PSButton = 0x00010000;
}
