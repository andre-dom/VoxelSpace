package;

import kha.input.KeyCode;

class Controls
{
	public var forward : Bool;
	public var backward: Bool;
	public var left : Bool;
	public var right: Bool;
	public var up   : Bool;
	public var down : Bool;
	public var rotateLeft   : Bool;
	public var rotateRight : Bool;
	public var sprint: Bool;
	public var lookUp : Bool;
	public var lookDown: Bool;
	
	public function new(): Void
	{
		reset();
	}
	
	public function reset(): Void
	{
		forward = false;
		backward = false;
		left  = false;
		right = false;
		up    = false;
		down  = false;
		rotateLeft = false;
		rotateRight = false;
		sprint = false;
		lookUp = false;
		lookDown = false;
	}
	
	public function buttonDown(button: KeyCode): Void
	{
		if (button == A ) left  = true;
		if (button == D) right = true;
		if (button == W   ) forward    = true;
		if (button == S ) backward  = true;
        if (button == Q ) rotateLeft  = true;
        if (button == E ) rotateRight  = true;
		if (button == Control ) down  = true;
        if (button == Space ) up  = true;
		if (button == Shift ) sprint  = true;
		if (button == Z ) lookUp  = true;
		if (button == X ) lookDown  = true;
	}
	
	public function buttonUp(button: KeyCode): Void
	{
		if (button == A ) left  = false;
		if (button == D) right = false;
		if (button == W   ) forward    = false;
		if (button == S ) backward  = false;
        if (button == Q ) rotateLeft  = false;
        if (button == E ) rotateRight  = false;
		if (button == Control ) down  = false;
        if (button == Space ) up  = false;
		if (button == Shift ) sprint  = false;
        if (button == Z ) lookUp  = false;
		if (button == X ) lookDown  = false;
	}
}