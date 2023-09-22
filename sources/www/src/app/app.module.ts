import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CjenikComponent } from './page/cjenik/cjenik.component';
import { FailComponent } from './page/fail/fail.component';
import { HvalaComponent } from './page/hvala/hvala.component';
import { IndexComponent } from './page/index/index.component';
import { KontaktComponent } from './page/kontakt/kontakt.component';
import { PitanjaComponent } from './page/pitanja/pitanja.component';
import { ReactiveFormsModule } from '@angular/forms';
import { PageComponent } from './page/page.component';
import { TitleComponent } from './title/title.component';
import { FooterComponent } from './footer/footer.component';

@NgModule({
  declarations: [
    AppComponent,
    CjenikComponent,
    FailComponent,
    HvalaComponent,
    IndexComponent,
    KontaktComponent,
    PitanjaComponent,
    PageComponent,
    TitleComponent,
    FooterComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
