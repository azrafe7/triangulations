package triangulations;
import triangulations.Geom2;
@:forward
abstract Edges( Array<Edge> ) from Array<Edge> to Array<Edge> {
    
    inline public function new( ?v: Array<Edge> ) {
        if( v == null ) v = getEmpty();
        this = v;
    }
    public inline static 
    function getEmpty(){
        return new Edges( new Array<Edge>() );
    }
    public /*inline*/ function set_fixedExternal( val: Bool ){
        for( e in this ) {
            e.fixed = val;
            e.external = val;
        }
        return val;
    }
    public var fixedExternal( never, set ):Bool;
    
    public inline
    function clone(): Edges {
        var e = new Edges();
        var l = this.length;
        var tempIn: Edge;
        var tempOut: Edge;
        for( i in 0...l ){
            e[i] = this[i].clone();       
        }
        return e;
    }
    
    public inline
    function getUnsure(): Array<Int> {
        var unsureEdges = new Array<Int>();
        var l = this.length;
        var lu = 0;
        for( j in 0...l ){
            if( !this[j].fixed ){
                unsureEdges[ lu ] = j;
                lu++;
            }
        }
        return unsureEdges;
    }
    
    public inline
    function add( e: Edges ): Edges {
        var l = this.length;
        var el = e.length;
        for( i in 0...el ) this[ l + i ] = e[ i ];
        return this;
    }
    @:from
    static public function fromArrayArray( arr: Array<Array<Null<Int>>> ) {
        var edges: Edges = getEmpty();
        var l = arr.length;
        for( i in 0...l ) {
            edges[ i ] = Edge.fromArray( arr[ i ] );
        }
        return edges;
    }
    
    
    //NOTE(az): trying to use a closer version of arraysubst*
    
    public static function subst2(wrappedEdge:Array<Edge>, x, y) {
      var edge:Edge = wrappedEdge[0];
      if (edge.p == x) edge.p = y;
      else edge.q = y;
    }
    
    public static function subst4(wrappedSideEdge:Array<SideEdge>, x, y) {
      var sideEdge:SideEdge = wrappedSideEdge[0];
      if (sideEdge.a == x) sideEdge.a = y; else
      if (sideEdge.b == x) sideEdge.b = y; else
      if (sideEdge.c == x) sideEdge.c = y;
      else              sideEdge.d = y;
    }
    
    // "ok"
    // Given edges along with their quad-edge datastructure, flips the chosen edge
    // j, maintaining the quad-edge structure integrity.
    public inline
    function flipEdge( coEdges: Edges, sideEdges: Array<SideEdge>, j: Int ) {
      var edge = this[j];
      var coEdge:Edge = coEdges[j];
      var se = sideEdges[j];
      var j0 = se.a;
      var j1 = se.b;
      var j2 = se.c;
      var j3 = se.d;
      
      // Amend side edges 
      subst2([coEdges[j0]], edge.p, coEdge.q);
      subst4([sideEdges[j0]], j , j1);
      subst4([sideEdges[j0]], j3, j );
      
      subst2([coEdges[j1]], edge.p, coEdge.p);
      subst4([sideEdges[j1]], j , j0);
      subst4([sideEdges[j1]], j2, j );
      
      subst2([coEdges[j2]], edge.q, coEdge.p);
      subst4([sideEdges[j2]], j , j3);
      subst4([sideEdges[j2]], j1, j );
      
      subst2([coEdges[j3]], edge.q, coEdge.q);
      subst4([sideEdges[j3]], j , j2);
      subst4([sideEdges[j3]], j0, j );
  
      //NOTE(az): see subst2/4
      /*coEdges[j0].substitute( edge.p, coEdge.q);
      se = sideEdges[j0];
      se.substitute( j, j1 );
      se.substitute( j3, j );

      coEdges[j1].substitute( edge.p, coEdge.p);
      se = sideEdges[j1];
      se.substitute( j , j0);
      se.substitute( j2, j );

      coEdges[j2].substitute( edge.q, coEdge.p);
      se = sideEdges[j2];
      se.substitute( j , j3);
      se.substitute( j1, j );

      coEdges[j3].substitute( edge.q, coEdge.q);
      se = sideEdges[j3];
      se.substitute( j , j2);
      se.substitute( j0, j );
      */
        
      // Flip
      this[j] = coEdges[j];
      coEdges[j] = edge.clone(); // in order to not effect the input

      // Amend primary edge
      var tmp = sideEdges[j].a;
      sideEdges[j].a = sideEdges[j].c;
      sideEdges[j].c = tmp;
    }
    public function toString() {
        var out = 'Edges( ';
        var e: Edge;
        for( i in 0...this.length ){
            e = this[i];
            out += e.toString() + ',';
        }
        out = out.substr( 0, out.length - 1 );
        out += ' )';
        return out;
    }
    // light trace 
    public function out(){
        var out = '';
        var e: Edge;
        var l = this.length;
        for( i in 0...l ){
            out += this[i].out() + ',';
        }
        out = out.substr( 0, out.length - 1 );
        return out;
    }
}
