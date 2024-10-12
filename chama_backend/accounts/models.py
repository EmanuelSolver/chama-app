from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    national_id = models.CharField(max_length=20, unique=True)
    mobile_no = models.CharField(max_length=15, unique=True)

class Chama(models.Model):
    CHAMA_MEET_SCHEDULE_CHOICES = [
        ('weekly', 'Weekly'),
        ('monthly', 'Monthly'),
    ]

    chama_name = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    no_of_members = models.IntegerField()
    meet_schedule = models.CharField(max_length=10, choices=CHAMA_MEET_SCHEDULE_CHOICES)
    day_or_date = models.CharField(max_length=10)  # For weekly: day, for monthly: date
    admin = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return self.chama_name
