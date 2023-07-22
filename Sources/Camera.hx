package;

class Camera
{
    public var x: Float;
    public var y: Float;
    public var h: Float;
    public var angle: Float;
    public var controls: Controls;
    public var speed = 50;
    public var tilt = 100.;

	public function new(x, y, h, angle)
    {
        this.x = x;
        this.y = y;
        this.h = h;
        this.angle = angle;
        controls = new Controls();
	}
}