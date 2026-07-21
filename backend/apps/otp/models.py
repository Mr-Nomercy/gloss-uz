from django.db import models


class OtpRequest(models.Model):
    class Channel(models.TextChoices):
        TELEGRAM = "telegram", "Telegram Gateway"
        SMS = "sms", "SMS"
        FLASH_CALL = "flash_call", "Flash Call"

    phone = models.CharField(max_length=20, db_index=True)
    channel = models.CharField(max_length=20, choices=Channel.choices)
    code_hash = models.CharField(max_length=128)
    attempts = models.PositiveSmallIntegerField(default=0)
    expires_at = models.DateTimeField()
    verified_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"OTP({self.phone}, {self.channel})"
