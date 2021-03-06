/*********************************************

  ペイントツールプログラム_Processing3

*********************************************

  パラメータ設定 

*********************************************/

//ＨＳＢ 透明度 太さ　y座標
int penH;
int penS;
int penB;
int penC;
int penW;

//セーブファイル名
//ここを変えればファイルを分けることができる
//全角不可

String file = "savedata";

//バックアップまでの時間間隔・間隔カウント
int backupdelay = 600000;//10分
int cnt = 1;

//バックアップカウント・ロードカウント・pngカウント
int backup = 1;
int backupLoad = 1;
int pngLoad;

//レイヤー・カーソル・クリア

PGraphics[] pg = new PGraphics[2];//読み書き
PGraphics cursor;
PGraphics clear;
int cursorSize = 5;

//pngロード画面
PImage im;//pngロード

//選択画面・レイヤー番号・png保存番号
int select = 1;
int png = 1;
int cpng = 1;

int key0; //key情報保存

//キャンバス座標・キャンバス・キャンバスサイズ・縦横比率
int x = 200;
int y = 100;
PImage canvas;
float canvas_w = 900;
float canvas_h = 450;
float ratio = 2;

//キャンバスサイズ
int size_x = 900,size_y = 450;

//ペン座標・カラー
float line_px,line_py,line_x,line_y; 
color Color;

//直線始点座標・オンオフ・初回認識
float point_x;
float point_y;
int on = 0;
int first = 1;


//ＨＳＢ最大値
final int COLOR_MAX = 100;

int penSize = 3;
int clarity = 100;

//ＨＳＢ空間　透明度　太さ　y座標 
int Hy1 = 20,Hy2,Hy3;

int Sy1 = 20,Sy2,Sy3;

int By1 = 20,By2,By3;

int Cy1 = 20,Cy2,Cy3;

int Wy1 = 340,Wy2,Wy3;

int Wby1 = 660,Wby2;

int Cby1 = 660,Cby2,Cby3 = 680,Cby4;


//ＨＳＢ空間  透明度  太さ　x座標・横幅
int Hx1 = 10,Hx2;

int Sx1 = 70,Sx2;

int Bx1 = 110,Bx2;

int Cx1 = 150,Cx2;

int Wx1 = 10,Wx2;

int Wbx1 = 10,Wbx2,Wbx3 = 45,Wbx4;

int Cbx1 = 90,Cbx2,Cbx3 = 110,Cbx4,Cbx5 = 140,Cbx6,Cbx7 = 160,Cbx8;


/*********************************************

  初期設定

*********************************************/


void setup(){            //初期設定

  fullScreen();
  //size(1365,767);
  noCursor(); //カーソルを消す
  colorMode(HSB,COLOR_MAX);//カラーモードをＨＳＢに変更
  noSmooth();//アンチエイリアスオフ
  
  keyCode = 66; //Bキー　初期をペンに設定
  key0 = keyCode;
  
  
  //ＨＳＢ　透明度　太さ　座標設定
  Hy2 = Hy1 + 280;
  Hy3 = Hy2 + 20;
  
  Sy2 = Sy1 + 280;
  Sy3 = Sy2 + 20;
  
  By2 = By1 + 280;
  By3 = By2 + 20;
  
  Cy2 = Cy1 + 280;
  Cy3 = Cy2 + 20;
  
  Wy2 = Wy1 + 280;
  Wy3 = Wy2 + 20;
  
  Wby2 = Wby1 + 16;
  
  Cby2 = Cby1 + 16;
  
  Cby4 = Cby3 + 16;
  
  //ＨＳＢ　透明度　太さ　横幅設定
  Hx2 = Hx1 + 50;
  
  Sx2 = Sx1 + 30;
  
  Bx2 = Bx1 + 30;
  
  Cx2 = Cx1 + 30;
  
  Wx2 = Wx1 + 50;
  
  Wbx2 = Wbx1 + 16;
  
  Wbx4 = Wbx3 + 16;
  
  Cbx2 = Cbx1 + 16;
  
  Cbx4 = Cbx3 + 16;

  Cbx6 = Cbx5 + 16;

  Cbx8 = Cbx7 + 16;

  
  //カーソルのy座標をＨＳＢ・透明度・太さに変換
  penH = Hy2;
  
  penS = Sy2;
  
  penB = By2;
  
  penC = Cy2;
  
  penW = Wy2;
  
  
    pg[0] = createGraphics(width,height);
    pg[1] = createGraphics(width,height);
    
    for( int i = 0; i < 1 ; i++ ){
    pg[i].beginDraw();
    pg[i].colorMode(HSB,COLOR_MAX);
    if( i == 0) pg[i].background(360,0,100);//白色背景
    pg[i].endDraw();
    }
  
  //グラフィックNull回避
    pg[1].beginDraw();
    pg[1].point(0,0);//気にならないところに表示
    pg[1].endDraw();
 
 
 //ロード画面リセット
 
 //   im = loadImage("/reset/data.png");
    
 //   pg[1].beginDraw();
 //   pg[1].pixels = im.pixels;
 //   //pg[1].updatePixels();
 //   pg[1].endDraw();
  
  keyCode = 66;
 
  canvas = pg[1].get(100,100,1100,500);//グラフィック画面読み込み
  cursor = createGraphics(width,height);
  clear = createGraphics(width,height);
  
}

/*********************************************

  メインループ

*********************************************/


void draw(){
  
  Color = penColor();//カラー設定
  
  putImage();//画面構成
  
  //拡大、縮小時のペンの場所補正
  line_x  = map(mouseX,x,x + size_x,0,width);
  line_px = map(pmouseX,x,x + size_x,0,width);
  line_y  = map(mouseY,y,y + size_y,0,height);
  line_py = map(pmouseY,y,y + size_y,0,height);
  
  backupload();
  windowclear();
  pngprint();
  transform();
  canvas_grab();
  putcursor();
  drawing();
  savedata();
  loaddata();
  drawLine();
  backup();
  
    if( keyCode == 27 )exit(); //Escキーで終了
  
  modetext();

}

/*********************************************

  関数

*********************************************/

/*********************************************

  ＨＳＢＣＷ（色相・彩度・明度・透明度・太さ）

*********************************************/

//ＨＳＢＣ・ペンカラー取得関数

color getMappedH(int h)
{
    return color(map(h,Hy1,Hy2,0,COLOR_MAX),COLOR_MAX,COLOR_MAX);
}

color getMappedS(int s)
{
    return color(map(penH,Hy1,Hy2,0,COLOR_MAX),map(s,Sy1,Sy2,0,COLOR_MAX),map(penB,By1,By2,0,COLOR_MAX));
}

color getMappedB(int b)
{
    return color(map(penH,Hy1,Hy2,0,COLOR_MAX),map(penS,Sy1,Sy2,0,COLOR_MAX),map(b,By1,By2,0,COLOR_MAX));
}

color getMappedC(int c)
{
    return color(map(penH,Hy1,Hy2,0,COLOR_MAX),map(penS,Sy1,Sy2,0,COLOR_MAX),map(penB,By1,By2,0,COLOR_MAX),map(c,Cy1,Cy2,0,COLOR_MAX));
}

color penColor()
{
    return color(map(penH,Hy1,Hy2,0,COLOR_MAX),map(penS,Sy1,Sy2,0,COLOR_MAX),map(penB,By1,By2,0,COLOR_MAX),map(penC,Cy1,Cy2,0,COLOR_MAX));
}


//ＨＳＢＣＷバー配置

void putHSBbar(){
  
  for(int y = Hy1; y < Hy2; y++){//色相バー
    stroke(getMappedH(y));
    line(Hx1,y,Hx2,y);
  }

  for(int y = Hy1; y < Hy1 + 100; y++){//色相バー
    stroke(getMappedH(y));
    line(Hx1,y,Hx2,y);
   }

  
  for(int y = Sy1; y < Sy2; y++){ //彩度バー
    stroke(getMappedS(y));
    line(Sx1,y,Sx2,y);
  }
  
  for(int y = By1; y < By2; y++){ //明度バー
    stroke(getMappedB(y));
    line(Bx1,y,Bx2,y);
  }
  
  for(int y = Cy1; y < Cy2; y++){ //透明度バー
    stroke(getMappedC(y));
    line(Cx1,y,Cx2,y);
  }
  
  for(int y = Wy1; y < Wy2; y++){ //太さバー
    stroke(Color);
    line(Wx1,y,Wx2,y);
  }
  
}

int Select(int c,int y1,int y2){
  int y = mouseY;
  c = y - 20;
  c = constrain(c,y1,y2);
  return c;
}


void HSBcursor(){
  if(select == 1 ){
    //色相選択カーソル
    putCursor( Hx1,Hx2,penH,getMappedH(penH));
    
    //彩度選択カーソル
    putCursor( Sx1,Sx2,penS,getMappedS(penS));
    
    //明度選択カーソル
    putCursor( Bx1,Bx2,penB,getMappedB(penB));
    
    //透明度選択カーソル
    putCursor( Cx1,Cx2,penC,getMappedC(penC));
    
    //太さ選択カーソル
    putCursor(Wx1,Wx2,penW,100);
  }
}

void putCursor(int x1,int x2 ,int y,color c){
  
    colorMode(HSB,100);
    stroke(360,0,0,50);
    for(int i = 0; i < 5 ; i++ ){
        line(x1 - 1,y - 1 + i,x2 + 1,y - 1 + i); 
    }
    stroke(c);
    for(int i = 0; i < 3 ; i++ ){
        line(x1,y + i,x2,y + i); 
    }
  
}
/*********************************************

  画面構成

*********************************************/

void putImage(){
  
  putGraphics();
  
  putCanvas();
  
  putSelect();
  
  HSBcursor();
  
}

void putGraphics(){
  
  background(255);//画面リセット
  //グラフィック表示    
  image(pg[0],0,0);
  image(g,0,0);
  image(pg[1],0,0);
}

void putCanvas(){
  
  //キャンバス表示
  canvas = get(0,0,width,height);
  background(360,0,50);
  canvas.resize(size_x,size_y);
  image(canvas,x,y);
  
}

void putSelect(){
  
  textSize(20);
  
  //選択画面ＯＮ・ＯＦＦ
  if( keyCode == 68 ){ //dキー
     
     select++;
     if( select >= 3 )select = 0;
    
    keyCode = key0;
  }

  
  if( select == 1 ){//左の選択画面表示
  //HSB背景
  noStroke(); 
  fill(0,0,70.70);
  rect(0,0,200,height);
  
  //ペンサイズ　マイナス値制限
  if(penSize <= 0 ) penSize = 1; 
  
  fill(0,100,100);
  text("HSB",15,15);
  text(penSize,30,650);
  text("CanvasSize",80,605);
  text("x:"+ size_x + "y:" + size_y,70,650);
  text("x",185,670);
  text("y",185,690);
  
  //太さ　＋　－　ボタン
  fill(0);
  rect(Wbx1,Wby1,16,16);
  rect(Wbx3,Wby1,16,16);
  stroke(360,0,100);
  strokeWeight(2);
  line(Wbx1 + 3,Wby1 + 8,Wbx1 + 12,Wby1 + 8);
  line(Wbx3 + 3,Wby1 + 8,Wbx3 + 12,Wby1 + 8);
  line(53,Wby1 + 4,53,Wby1 + 12);
  
  //キャンバスサイズ　＋　－　ボタン
  fill(0);
  rect(Cbx1,Cby1,16,16);
  rect(Cbx3,Cby1,16,16);
  rect(Cbx5,Cby1,16,16);
  rect(Cbx7,Cby1,16,16);
  rect(Cbx1,Cby2,16,16);
  rect(Cbx3,Cby2,16,16);
  rect(Cbx5,Cby2,16,16);
  rect(Cbx7,Cby2,16,16);
  stroke(360,0,100);
  strokeWeight(2);
  line(Cbx1 + 3,Cby1 + 8,Cbx1 + 12,Cby1 + 8);
  line(Cbx3 + 3,Cby1 + 8,Cbx3 + 12,Cby1 + 8);
  line(Cbx5 + 3,Cby1 + 8,Cbx5 + 12,Cby1 + 8);
  line(Cbx7 + 3,Cby1 + 8,Cbx7 + 12,Cby1 + 8);
  line(Cbx1 + 3,Cby2 + 8,Cbx1 + 12,Cby2 + 8);
  line(Cbx3 + 3,Cby2 + 8,Cbx3 + 12,Cby2 + 8);
  line(Cbx5 + 3,Cby2 + 8,Cbx5 + 12,Cby2 + 8);
  line(Cbx7 + 3,Cby2 + 8,Cbx7 + 12,Cby2 + 8);
  
  line(148,Cby1 + 4,148,Cby1 + 12);
  line(168,Cby1 + 4,168,Cby1 + 12);
  line(148,Cby2 + 4,148,Cby2 + 12);
  line(168,Cby2 + 4,168,Cby2 + 12);
  
  //キャンバスサイズ決定ボタン
  fill(0);
  rect(85,610,100,20);
  fill(360,0,100);
  text("click",110,626);
  
  putHSBbar();
  
  stroke(-1);
  fill(Color);
  if( keyCode == 69 )//ｅキー
  {
    fill(360,0,100);//白色
  }
  rect(80,330,100,100); //現在のペン色
  }
  
  
  if( select >= 1 ){//右の選択画面表示
    
  //機能・レイヤー背景
  noStroke();
  fill(0,0,70.70);
  rect(1100,0,width,height);
  
  //ペンボタン
  Fillbutton(66);
  puttextln(1110,10,"Pen","B");
  
  //消しゴムボタン
  Fillbutton(69);
  puttextln(1210,10,"White","E");
  
  //直線ボタン
  Fillbutton(84);
  puttextln(1110,110,"Line","T");
  
  
  //長方形ボタン
  Fillbutton(81);
  puttextln(1210,110,"Rect","Q");
  
  
  //楕円ボタン
  Fillbutton(67);
  puttextln(1110,210,"Circle","C");
  
  
  //画面クリアボタン
  text("Clear",1227,260);
  Fillbutton(10);
  puttextln(1210,210,"Clear","Enter");
  
  
  //png保存ボタン
  Fillbutton(80);
  puttextln(1110,310,"Export","P");
  
   //掴むボタン
  Fillbutton(72);
  puttextln(1210,310,"Grab","H");
  
  //セーブボタン
  Fillbutton(83);
  puttextln(1110,410,"Save","S");
  
  //ロードボタン
  Fillbutton(76);
  puttextln(1210,410,"Load","L");
  
  //バックアップボタン
  Fillbutton(65);
  puttextln(1110,510,"Backup","A");
  
  //バックアップロードボタン
  Fillbutton(85);
  puttextln(1210,510,"BkLoad","U");
  
  
  //キャンバス位置リセットボタン
  Fillbutton(82);
  puttextln(1110,610,"cReset","R");
  
  //終了ボタン
  Fillbutton(27);
  rect(1250,650,60,60);
  fill(0);
  text("exit",1250 + 10,650 +30);
  text("Esc",1250 + 15,650 + 50);
  
  
  }
}

void Fillbutton(int Code){
  stroke(-1);
  if( keyCode == Code )fill( 60 );
  else fill(40);
}

void puttextln(int x,int y,String s1,String s2){
  rect(x,y,90,90);
  fill(0);
  text(s1,x + 15,y + 35);
  text(s2,x + 20,y + 60);
}

/*********************************************

  ペイント機能

*********************************************/

void drawLine(){        //ペン　・　消しゴム（白色ペン）
  if( mousePressed == true ){ // マウスを押してるとき
  if( keyCode == 66 || keyCode == 69){  //Ｂキー  or Ｅキー
  
    key0 = keyCode; // キー情報保存
    
    pg[1].beginDraw();
    pg[1].stroke(Color);
    pg[1].strokeWeight(penSize);
    pg[1].colorMode(HSB,COLOR_MAX);
    if( keyCode == 69 )pg[1].stroke(360,0,100,map(penC,Cy1,Cy2,0,COLOR_MAX));//白色
   
    //セレクト画面操作中にペンをオフにする
    if( select == 0 || mouseX > 200 && mouseX < 1100 )
    {
      pg[1].line(line_px,line_py,line_x,line_y);
    }
    pg[1].endDraw();
    putcursor();
  }
  }
}

void drawing(){
  if( keyCode == 84 || keyCode == 81 || keyCode == 67 ){
    
    key0 = keyCode;
    
    if( mousePressed == true && on == 0 )
    {
      point_x = line_x;
      point_y = line_y;
      on = 1;
    }
      if( mousePressed == false && on == 1 ) 
      {
        pg[1].beginDraw();
        pg[1].noFill();
        pg[1].stroke(Color);
        pg[1].strokeWeight(penSize);
        if( keyCode == 84 )pg[1].line( point_x,point_y,line_px,line_py);//Ｔ
        if( keyCode == 81 )pg[1].rect( point_x,point_y, line_x - point_x , line_y - point_y );//Ｑ
        if( keyCode == 67 )pg[1].ellipse( point_x,point_y,( line_x - point_x ) * 2, ( line_y - point_y ) * 2 );//Ｃ
        pg[1].endDraw();
        putcursor();
        on = 0;
      }
  }
}


void putcursor(){        //カーソル表示
  
    cursorSize = penSize;
    cursorSize /= 1.5 ; //大きさ調整
    //ペンサイズが小さいときや選択画面の時
    if( penSize < 5 || select == 1 && mouseX < 200 || select >= 1 && mouseX > 1100 )
    {
      cursorSize = 5;//サイズを５に変換
    }
    cursor.beginDraw();          
    cursor.colorMode(RGB,255);
    cursor.background(256);
    cursor.strokeWeight(2);
    cursor.stroke(0,80);
    cursor.fill(255,80);
    cursor.ellipse(mouseX,mouseY,cursorSize,cursorSize);
    cursor.endDraw();
    image(cursor,0,0);
  
}

void windowclear(){  //キャンバス白紙
  if( keyCode == 10 ) //Ｅｎｔｅｒキー
  {
    
     clear.beginDraw();
     clear.background(0);
     clear.endDraw();
    
     pg[1].mask(clear); //グラフィッククリア
     pg[1].mask(clear);//ロードpng画面クリア
     pg[1].updatePixels();
  }
}


void canvas_grab(){  //キャンバスを掴む
  if(!keyPressed){
  if( keyCode == 72){ //Ｈキー
     key0 = keyCode;
    if(mousePressed ){
      x += mouseX - pmouseX;
      y += mouseY - pmouseY;
    }
  }
  }
}


void transform(){//キャンバス拡大、縮小
  if(!keyPressed){
    if( keyCode == 59 ){        //拡大
    if( ratio > 1 )
    {
      size_x += 10 * ratio;
      size_y += 10;
    }
    else if( ratio < 1)
    {
      size_x += 10;
      size_y += 10 * ratio;
    }
    else 
    {
      size_x += 10;
      size_y += 10; 
    }
      x -= 5;
      y -= 5;
      keyCode = key0;
    }
    else if( keyCode == 45){   //縮小
    if( ratio > 1 )
    {
      size_x -= 10 * ratio;
      size_y -= 10;
    }
    else if( ratio < 1)
    {
      size_x -= 10;
      size_y -= 10 * ratio;
    }
    else 
    {
      size_x -= 10;
      size_y -= 10; 
    }
      if(size_x < 10) size_x = 10;
      else x += 5;
      if(size_y < 10) size_y = 10;
      else y += 5;
      keyCode = key0;
    }
  }
  if(!keyPressed){
    if( keyCode == 82){   //　Ｒキーを押したとき
      size_x = int(canvas_w);          //キャンバス位置リセット;
      size_y = int(canvas_h);
      x = 200;
      y = 100;
      keyCode = key0;
    }
  }
}

void mouseWheel(MouseEvent event) {//マウスホイール操作
  float e = event.getCount();
  if( e == 1 ){               //拡大
    if( ratio > 1 )
    {
      size_x += 10 * ratio;
      size_y += 10;
    }
    else if( ratio < 1)
    {
      size_x += 10;
      size_y += 10 * ratio;
    }
    else 
    {
      size_x += 10;
      size_y += 10; 
    }
      x -= 5;
      y -= 5;
  }
  else{                       //縮小
    if( ratio > 1 )
    {
      size_x -= 10 * ratio;
      size_y -= 10;
    }
    else if( ratio < 1)
    {
      size_x -= 10;
      size_y -= 10 * ratio;
    }
    else 
    {
      size_x += 10;
      size_y += 10; 
    }
      if(size_x < 10) size_x = 10;
      else x += 5;
      if(size_y < 10) size_y = 10;
      else y += 5;
  }
}
/*********************************************

  ボタン範囲設定

*********************************************/

void mousePressed(){
  if( select == 1 ){
  if( Hx1 < mouseX && mouseX < Hx2 && Hy1 < mouseY && mouseY < Hy3 ){        //色相バー範囲
      penH = Select(penH,Hy1,Hy2);
  }
  else if( Sx1 < mouseX && mouseX < Sx2 && Sy1 < mouseY && mouseY < Sy3 ){  //彩度バー範囲
      penS = Select(penS,Sy1,Sy2);
  }
  else if( Bx1 < mouseX && mouseX < Bx2 && By1 < mouseY && mouseY < By3 ){   //明度バー範囲
      penB = Select(penB,By1,By2);
  }
  else if( Cx1 < mouseX && mouseX < Cx2 && Cy1 < mouseY && mouseY < Cy3 ){   //透明度バー範囲
      penC = Select(penC,Cy1,Cy2);
  }
  else if( Wx1 < mouseX && mouseX < Wx2 && Wy1 < mouseY && mouseY < Wy3 ){   //太さバー範囲
      penW = Select(penW,Wy1,Wy2);
      penSize = int( map(penW,340,620,100,1) );//ｙ座標を１～１００の数値に変換
  }
  else if( Wbx1 < mouseX && mouseX < Wbx2 && Wby1 < mouseY && mouseY < Wby2 ){   //太さ - ボタン範囲
      penSize -= 1;
      penW = int(map(penSize,100,1,340,620));
  }
  else if( Wbx3 < mouseX && mouseX < Wbx4 && Wby1 < mouseY && mouseY < Wby2 ){   //太さ + ボタン範囲
      penSize += 1;
      penW = int(map(penSize,100,1,340,620));
      if(penSize >= 100 ){ //大きさ　＋１０
         penSize += 10;
         penW = 340;
      }
  }
  else if( Cbx1 < mouseX && mouseX < Cbx2 && Cby1 < mouseY && mouseY < Cby2 ){   //キャンバスサイズ X -100 ボタン範囲
      size_x -= 100;
  }
  else if( Cbx3 < mouseX && mouseX < Cbx4 && Cby1 < mouseY && mouseY < Cby2 ){   //キャンバスサイズ X -10 ボタン範囲
      size_x -= 10;
  }
  else if( Cbx5 < mouseX && mouseX < Cbx6 && Cby1 < mouseY && mouseY < Cby2 ){   //キャンバスサイズ X +10 ボタン範囲
      size_x += 10;
  }
  else if( Cbx7 < mouseX && mouseX < Cbx8 && Cby1 < mouseY && mouseY < Cby2 ){   //キャンバスサイズ X +100 ボタン範囲
      size_x += 100;
  }
  else if( Cbx1 < mouseX && mouseX < Cbx2 && Cby3 < mouseY && mouseY < Cby4 ){   //キャンバスサイズ Y -100 ボタン範囲
      size_y -= 100;
  }
  else if( Cbx3 < mouseX && mouseX < Cbx4 && Cby3 < mouseY && mouseY < Cby4 ){   //キャンバスサイズ Y -10 ボタン範囲
      size_y -= 10;
  }
  else if( Cbx5 < mouseX && mouseX < Cbx6 && Cby3 < mouseY && mouseY < Cby4 ){   //キャンバスサイズ Y +10 ボタン範囲
      size_y += 10;
  }
  else if( Cbx7 < mouseX && mouseX < Cbx8 && Cby3 < mouseY && mouseY < Cby4 ){   //キャンバスサイズ Y +100 ボタン範囲
      size_y += 100;
  }
  else if( 85 < mouseX && mouseX < 185 && 610 < mouseY && mouseY < 630 ){   //キャンバスサイズ 比率固定
      canvas_w = size_x;
      canvas_h = size_y;
      ratio = canvas_w / canvas_h;
  }
  }
  if( select >= 1 ){
    if( mouseX > 1110 && mouseX < 1200 && mouseY > 10 && mouseY < 100 ){
       keyCode = 66; //Ｂキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 10 && mouseY < 100 ){
       keyCode = 69; //Ｅキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 110 && mouseY < 200 ){
       keyCode = 84; //Ｔキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 110 && mouseY < 200 ){
       keyCode = 81; //Ｑキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 210 && mouseY < 300 ){
       keyCode = 67 ; //Ｃキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 210 && mouseY < 300 ){
       keyCode = 10 ; //Ｅｎｔｅｒキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 310 && mouseY < 400 ){
       keyCode = 80; //Ｐキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 310 && mouseY < 400 ){
       keyCode = 72; //Ｈキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 410 && mouseY < 500 ){
       keyCode = 83 ; //Ｓキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 410 && mouseY < 500 ){
       keyCode = 76 ; //Ｌキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 510 && mouseY < 600 ){
       keyCode = 65 ; //Ａキー
    }
    else if( mouseX > 1210 && mouseX < 1300 && mouseY > 510 && mouseY < 600 ){
       keyCode = 85 ; //Ｕキー
    }
    else if( mouseX > 1110 && mouseX < 1200 && mouseY > 610 && mouseY < 700 ){
       keyCode = 82 ; //Ｒキー
    }
    else if( mouseX > 1250 && mouseX < 1310 && mouseY > 650 && mouseY < 710 ){
       keyCode = 27 ; //Ｅｓｃキー
    }
    
  }
}

void mouseDragged(){
  if( select == 1 ){
  if( Hx1 < mouseX && mouseX < Hx2 && Hy1 < mouseY && mouseY < Hy3 ){        //色相バー範囲
      penH = Select(penH,Hy1,Hy2);
  }
  else if( Sx1 < mouseX && mouseX < Sx2 && Sy1 < mouseY && mouseY < Sy3 ){  //彩度バー範囲
      penS = Select(penS,Sy1,Sy2);
  }
  else if( Bx1 < mouseX && mouseX < Bx2 && By1 < mouseY && mouseY < By3 ){   //明度バー範囲
      penB = Select(penB,By1,By2);
  }
  else if( Cx1 < mouseX && mouseX < Cx2 && Cy1 < mouseY && mouseY < Cy3 ){   //透明度バー範囲
      penC = Select(penC,Cy1,Cy2);
  }
  else if( Wx1 < mouseX && mouseX < Wx2 && Wy1 < mouseY && mouseY < Wy3 ){   //太さバー範囲
      penW = Select(penW,Wy1,Wy2);
      penSize = int( map(penW,340,620,100,1) );
  }
  else if( key == 'h'){
      x += mouseX - pmouseX;
      y += mouseY - pmouseY;
    }
  }
}

/*********************************************

  キーコード状態表示

*********************************************/

void modetext(){
  
  switch( keyCode ){
    
  case 10:
    text("backup",200,30);         //Ｅｎｔｅｒ
    keyCode = key0;
    break;
    
  case 65:
    text("backup",200,30);         //Ａ
    keyCode = key0;
    break;
    
  case 66:
    text("pen",200,30);            //Ｂ
    break;
    
 case 67:
     text("Circle",200,30);         //Ｃ
     break;
     
  case 69:
    text("Eraser",200,30);         //Ｅ
    break;
    
 case 72:
     text("grab",200,30);           //Ｈ
     break;
     
 case 76:
     text("load",200,30);           //Ｌ
     keyCode = key0;
     break;
    
 case 80:
     text("Pngsave",200,30);        //Ｐ
     keyCode = key0;
     break;
     
 case 81:
     text("Rect",200,30);           //Ｑ
     break;
     
 case 83:
     text("save",200,30);           //Ｓ
     keyCode = key0;
     break;
     
 case 84:
     text("Straight Line",200,30);  //Ｔ
     break;
     
 case 85:
     text("backupload",200,30);     //Ｕ
     keyCode = key0;
     break;
     
  default:
    keyCode = key0;//定義のないキーが押された場合戻す
  }
}
/*********************************************

  データ保存

*********************************************/

void savedata(){//キャンバス画面セーブ
  if( keyCode == 83 ) //Ｓキー
  {
    putGraphics();
    
    im = pg[1].get( 0 , 0 ,width,height);
    im.save("/" + file + "/data.png");
    
    putImage();
  }
}

void backup(){//キャンバス画面バックアップ
  
  if( backupdelay <= millis()/cnt || keyCode == 65){//10分経つごとに or  Ａキー
  
    putGraphics();
    
    backupLoad = 0;
    do{
      backupLoad++;
      im = loadImage("/backup/data"+ backupLoad +".png");
    }
    while( im != null);
    
    backup = backupLoad;
    
      im = pg[1].get( 0 , 0 ,width,height);
      im.save("/backup/data"+ backup  +".png");
      
    if(  backupdelay <= millis()/cnt ) cnt++;
    
    putImage();
    
  }
  
}

void backupload(){ //バックアップデータロード
  
  if( keyCode == 85 ){ //Ｕキー
    
    
    im = loadImage("/backup/data"+ backupLoad +".png");
    backupLoad++;
    
    if( im == null ) 
    {
      backupLoad = 1;
    }
    else{
      pg[1].beginDraw();
      pg[1].pixels = im.pixels;
      pg[1].updatePixels();
      pg[1].endDraw();
    }
  }
    
  
}

void loaddata(){//セーブデータロード
 if( keyCode == 76 ) //Ｌキー
 {
   
    im = loadImage("/"+ file +"/data.png");
    
    if( im != null ){
      pg[1].beginDraw();
      pg[1].pixels = im.pixels;
      pg[1].updatePixels();
      pg[1].endDraw();
    }
 }
}


void pngprint(){ //pngファイル保存
  
  if(!keyPressed){
  if(keyCode  == 80 ) { //pキー
      size_x = int(canvas_w);          //キャンバスサイズリセット;
      size_y = int(canvas_h);
      x = 200;
      y = 100;
      
    pngLoad = 0;
    do{
      pngLoad++;
      im = loadImage("png/canvas"+ pngLoad +".png");
    }
    while( im != null);
    
    png = pngLoad;
    
     canvas.save("png/canvas"+ png +".png");
  }
  }
}
