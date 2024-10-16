from django.db import models
from django.contrib.auth.models import AbstractUser


class CustomUser(AbstractUser):
    USER_ROLE_CHOICES = [
        ('chamaMember', 'Chama Member'),
        ('appAdmin', 'App Admin'),
    ]
    
    user_role = models.CharField(
        max_length=20,
        choices=USER_ROLE_CHOICES,
        default='chamaMember'
    )
    national_id = models.CharField(max_length=20, unique=True)
    mobile_no = models.CharField(max_length=15, unique=True)


class Chama(models.Model):
    CHAMA_MEET_SCHEDULE_CHOICES = [
        ('weekly', 'Weekly'),
        ('monthly', 'Monthly'),
    ]

    chama_name = models.CharField(max_length=100)
    registration_no = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    meet_schedule = models.CharField(max_length=10, choices=CHAMA_MEET_SCHEDULE_CHOICES)
    day_or_date = models.CharField(max_length=10)  # For weekly: day, for monthly: date

    def __str__(self):
        return self.chama_name


class ChamaMembership(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    chama = models.ForeignKey(Chama, on_delete=models.CASCADE)
    date_joined = models.DateTimeField(auto_now_add=True)
    is_admin = models.BooleanField(default=False)  # Field to check if the user is admin of the Chama

    def __str__(self):
        return f"{self.user.username} - {self.chama.chama_name}"


