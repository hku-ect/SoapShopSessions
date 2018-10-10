class Digit {
  PVector pos; // posizione del punteggio
  PGraphics pg;
  int w;
  int margin;
  int x, y;
  
  /////////////////////////////////////////////////////////////////////////////// DIGIT
  Digit(PVector pos_, int w_) {
    pos = pos_.get();
    w = 4*w_;
    margin = w_;
    pg = createGraphics(w+2*margin, 2*w+w_+2*margin);
    x = margin;
    y = margin;
  }
  
  ////////////////////////////////////////////////////////////////////////// DRAW DIGIT
  void draw_digit(int n_, int alpha_) {
    
    pushMatrix();
    translate(pos.x, pos.y);
 
    switch (n_) {
      case 1:
        draw_segment('B', 255);
        draw_segment('C', 255);
      break;
      case 2:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('D', 255);
        draw_segment('E', 255);
        draw_segment('G', 255);
      break;
      case 3:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('G', 255);
      break;
      case 4:
        draw_segment('B', 255);
        draw_segment('C', 255);
        draw_segment('F', 255);
        draw_segment('G', 255);
      break;
      case 5:
        draw_segment('A', 255);
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('F', 255);
        draw_segment('G', 255);
        break;
      case 6:
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('E', 255);
        draw_segment('F', 255);
        draw_segment('G', 255);
      break;
      case 7:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('C', 255);
      break;
      case 8:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('E', 255);
        draw_segment('F', 255);
        draw_segment('G', 255);
      break;
      case 9:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('F', 255);
        draw_segment('G', 255);
      break;
      case 0:
        draw_segment('A', 255);
        draw_segment('B', 255);
        draw_segment('C', 255);
        draw_segment('D', 255);
        draw_segment('E', 255);
        draw_segment('F', 255);        
      break;           
    }
    popMatrix();
  }
  

  //////////////////////////////////////////////////////////////////////// DRAW SEGMENT
  void draw_segment(char a_, int alpha_) {
    
    pushStyle();
    stroke(255, 255, 255, alpha_);
    strokeWeight(margin+1);
    strokeCap(PROJECT);
    strokeJoin(MITER);
    
    float h1 = w;
    float h2 = (w/4) * 5;
    
    switch (a_) {
      case 'A':
        line(x, y, x + w, y);
      break;
      case 'B':
        line(x + w, y, x + w, y + h1);
      break;
      case 'C':
        line(x + w, y + h1, x + w, y + h1 + h2);
      break;
      case 'D':
        line(x, y + h1 + h2, x + w, y + h1 + h2);
      break;
      case 'E':
        line(x, y + h1 + h2, x, y + h1);
      break;
      case 'F':
        line(x, y + h1, x, y);
      break;
      case 'G':
        line(x, y + h1, x + w, y + h1);
      break;
    }
    popStyle();
  }  
}
