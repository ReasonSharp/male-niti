import { Component, OnInit, Renderer2 } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-kontakt',
  templateUrl: './kontakt.component.html',
  styleUrls: ['./kontakt.component.css']
})
export class KontaktComponent implements OnInit {
 contactForm: FormGroup = new FormGroup({
  queryType: new FormControl("Upit", [ Validators.required ]),
  email: new FormControl(null, [ Validators.required, Validators.email ]),
  message: new FormControl("Upit", [ Validators.required ])
 });

 constructor(private route: ActivatedRoute,
             private renderer: Renderer2) {}

 ngOnInit(): void {
  this.route.params.subscribe(params => {
   const t = params['t'] === undefined ? "Upit" : params['t'];
   const a = params['a'] === undefined ? "Upit" : params['a'];
   this.fillFormFields(t, a);
  });
 }
 fillFormFields(t: string, a: string) {
  let f1 = t;
  let f2 = a;
  if (t != "Upit") {
   f2 = "Zanima me " + a + ".";
   if (t == "MaliBackup3") {
    f2 += "\nTraženi parametri:\n";
    f2 += "Broj instalacija: \n";
    f2 += "Duljina zadržavanja tjednih backupa: \n";
    f2 += "Veličina baze podataka: \n";
    f2 += "Veličina dodatnih datoteka za backup: ";
   }
  }
  this.contactForm = new FormGroup({
    queryType: new FormControl(f1, [ Validators.required ]),
    email: new FormControl(null, [ Validators.required, Validators.email ]),
    message: new FormControl(f2, [ Validators.required ])
  });
 }

 isEmailTouchedAndInvalid() : boolean | undefined {
  const isValid = this.contactForm.get('email')?.valid;
  const isTouched = this.contactForm.get('email')?.touched;
  return !isValid && isTouched;
 }
 isEmailRequirementFailed() : boolean | undefined {
  const errs = this.contactForm.get('email')?.errors;
  if (errs != null) return errs['required'];
  return false;
 }
 isEmailFormatFailed() : boolean | undefined {
  const errs = this.contactForm.get('email')?.errors;
  if (errs != null) return errs['email'];
  return false;
 }

 isMessageTouchedAndInvalid() : boolean | undefined {
  const isValid = this.contactForm.get('message')?.valid;
  const isTouched = this.contactForm.get('message')?.touched;
  return !isValid && isTouched;
 }

 scrollToTop() {
  const target = this.renderer.selectRootElement('#top');
  if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start'});
 }
}
