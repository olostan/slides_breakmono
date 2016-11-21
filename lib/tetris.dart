import 'dart:math';
import 'package:angular2/core.dart';
import 'dart:async';
import "dart:html";

@Component(
  selector:'tetris',
  styleUrls: const ['./tetris.css'],
  templateUrl: 'tetris.html',
)

class Tetris {
  static const width=10;
  static const height=20;
  final List<List<int>> grid;

  num initial = 0;

  @Input('initial') @Optional()
  void set initialStr(String value) {
    initial = num.parse(value);
  }

  Timer timer;
  Tetris(): grid=new List<List<int>>.generate(height, (_) => new List<int>.filled(width,0)) {
    document.addEventListener('keypress',keypressed);
  }
  void start() {
    if (timer!=null) timer.cancel();
    grid.setAll(0,new List<List<int>>.generate(height, (_) => new List<int>.filled(width,0)));
    grid.setRange(height-initial,height,new List<List<int>>.generate(initial,(_) => new List<int>.generate(width,(_)=> rand.nextInt(2))));

    cbX = width ~/ 2;
    cbY = 0;
    block = newBlock();
    iterate();
    state = 1;
  }
  var state = 0;
  void keypressed(Event e) {
    var kbdE = e as KeyboardEvent;
    if (kbdE.keyCode==119) {
      rotateBlock();
    } else if (kbdE.keyCode==97) {
      drawBlock(0);
      if (canMoveSide(-1))
        cbX--;

      drawBlock(1);
    }else if (kbdE.keyCode==100) {
      drawBlock(0);
      if (canMoveSide(1))
        cbX++;

      drawBlock(1);
    } else if (kbdE.keyCode==115) {
      drawBlock(0);
      if (canMoveDown())
        cbY++;
      drawBlock(1);
    }
  }
  rotateBlock() {
    var newBlock = new List<List<int>>.generate(block[0].length,(_) => new List.filled(block.length,0));
    for(var r=0;r<block.length;r++)
      for (var c = 0;c<block[r].length;c++)
        newBlock[c][r] = block[block.length-r-1][c];
    drawBlock(0);
    block = newBlock;
    drawBlock(1);
  }
  static const blocks = const [
    const[ const[1],const[1],const[1],const[1]],
    const[ const[1,1],const[1,1]],
    const[ const[1,0],const[1,1],const[1,0]],
    const[ const[1,1],const [1,0],const [1,0]],
    const[ const[1,1],const [0,1],const [0,1]],
    const[ const[1,0],const [1,1],const [0,1]],
    const[ const[0,1],const [1,1],const [1,0]],
  ];
  var cbX = 4;
  var cbY = 0;
  var speed = 300;

  @Input('speed') @Optional()
  void set speedStr(String value) {
    speed = int.parse(value);
  }


  List<List<int>> block;
  final rand = new Random();
  List<List<int>> newBlock() {
    var n = rand.nextInt(blocks.length);
    var block = blocks[n];
    // TODO: rotate
    return block;
  }


  iterate() {
    drawBlock(0);
    if (canMoveDown())  {
      cbY++;
      drawBlock(1);
      timer = new Timer(new Duration(milliseconds: speed), iterate);
    } else {
      drawBlock(1);
      for (var r=height-1;r>1;r--) {
        if (grid[r].every( (e) => e==1)) {
          for (var nr = r;nr>1;nr--)
            grid[nr].setAll(0,grid[nr-1]);
          r++;
        }
      }

      cbX = width ~/ 2;
      cbY=0;
      block = newBlock();
      if (canMoveDown()) {
        timer = new Timer(new Duration(milliseconds: speed), iterate);
      } else state = 2;
    }

  }

  bool canMoveDown() {
    if (cbY>=height-block.length) return false;
    for(var r=0;r<block.length;r++)
      for (var c = 0;c<block[r].length;c++)
        if (block[r][c]!=0 && grid[cbY+r+1][cbX+c]!=0) return false;
    return true;
  }
  bool canMoveSide(offset) {
    if (cbX+offset<0||cbX+offset+block[0].length>width) return false;
    for(var r=0;r<block.length;r++)
      for (var c = 0;c<block[r].length;c++)
        if (block[r][c]!=0 && grid[cbY+r][cbX+c+offset]!=0) return false;
    return true;
  }

  void drawBlock(col) {
    for(var r=0;r<block.length;r++)
        for (var c = 0;c<block[r].length;c++)
            if (block[r][c]!=0) grid[cbY+r][cbX+c] = col;
  }

}


//List<List<int>>