from rest_framework import serializers
from .models import CustomUser, Chama

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['first_name', 'last_name', 'username', 'email', 'national_id', 'mobile_no']

class ChamaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chama
        fields = ['chama_name', 'location', 'registration_no', 'meet_schedule', 'day_or_date', 'admin']
