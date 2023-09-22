import { Component, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-hvala',
  templateUrl: './hvala.component.html',
  styleUrls: ['./hvala.component.css']
})
export class HvalaComponent {
 constructor (private renderer: Renderer2){}

 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
