import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { User } from '../../common/user';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
})
export class RegisterComponent implements OnInit {
  registerForm!: FormGroup;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.registerForm = this.fb.group({
      fullName: ['', [Validators.required, Validators.minLength(2)]],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]],
    });
  }

  onSubmit(): void {
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    const user: User = this.registerForm.value;
    this.submitting = true;

    this.authService.register(user).subscribe({
      next: () => {
        this.submitting = false;
        this.router.navigate(['/login']);
      },
      error: () => {
        this.submitting = false;
        alert('Registration failed. Please try again.');
      },
    });
  }

  hasError(controlName: string, errorName: string): boolean {
    const control = this.registerForm.get(controlName);
    return !!control && control.touched && control.hasError(errorName);
  }
}

