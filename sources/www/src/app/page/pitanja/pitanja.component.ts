import { Component, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-pitanja',
  templateUrl: './pitanja.component.html',
  styleUrls: ['./pitanja.component.css']
})
export class PitanjaComponent {
 constructor (private renderer: Renderer2){}
   
 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
