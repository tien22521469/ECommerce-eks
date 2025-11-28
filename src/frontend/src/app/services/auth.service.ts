import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../common/user';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private readonly registerUrl = `${environment.userServiceUrl}/users/register`;

  constructor(private http: HttpClient) {}

  register(user: User): Observable<any> {
    return this.http.post(this.registerUrl, user);
  }
}

