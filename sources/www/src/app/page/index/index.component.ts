import { Component, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css']
})
export class IndexComponent {
 constructor (private renderer: Renderer2){}

 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
