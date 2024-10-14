from rest_framework import serializers
from .models import CustomUser, Chama
from django.contrib.auth.hashers import make_password

class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)  # Ensure password is write-only

    class Meta:
        model = CustomUser
        fields = ['first_name', 'last_name', 'username', 'email', 'national_id', 'mobile_no', 'user_role', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        # Ensure the password is hashed before saving
        validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)


class ChamaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chama
        fields = ['chama_name', 'location', 'registration_no', 'meet_schedule', 'day_or_date', 'admin']
