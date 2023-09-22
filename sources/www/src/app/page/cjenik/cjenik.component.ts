import { Component, Renderer2 } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-cjenik',
  templateUrl: './cjenik.component.html',
  styleUrls: ['./cjenik.component.css']
})
export class CjenikComponent {
 constructor (private router: Router,
              private renderer: Renderer2) {}

 goToContactForm(t: string, a: string) {
  this.router.navigate(['/kontakt', t, a]);
 }

 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
