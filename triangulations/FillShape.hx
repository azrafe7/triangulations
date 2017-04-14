package triangulations;
import triangulations.Vertices;
import triangulations.Edges;
import triangulations.Face;

class FillShape {
    public var vertices: Vertices;
    public var edges: Edges;
    public var faces: Array<Array<Face>>;
    public function new(){}
    public inline 
    function scale( s: Float ){
        vertices.scale( s );
    }
    public inline 
    function translate( x: Float, y: Float ){
        vertices.translate( x, y );
    }
}
