import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CjenikComponent } from './page/cjenik/cjenik.component';
import { FailComponent } from './page/fail/fail.component';
import { HvalaComponent } from './page/hvala/hvala.component';
import { IndexComponent } from './page/index/index.component';
import { KontaktComponent } from './page/kontakt/kontakt.component';
import { PitanjaComponent } from './page/pitanja/pitanja.component';

const routes: Routes = [
    { path: 'cjenik', component: CjenikComponent },
    { path: 'fail', component: FailComponent },
    { path: 'hvala', component: HvalaComponent },
    { path: 'index', component: IndexComponent },
    { path: 'kontakt', component: KontaktComponent },
    { path: 'kontakt/:t/:a', component: KontaktComponent },
    { path: 'pitanja', component: PitanjaComponent },
    { path: '', redirectTo: '/index', pathMatch: 'full' },
    { path: '**', redirectTo: '/index' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
