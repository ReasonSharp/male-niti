import { Component, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-fail',
  templateUrl: './fail.component.html',
  styleUrls: ['./fail.component.css']
})
export class FailComponent {
 constructor (private renderer: Renderer2){}

 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
