# 🎰 Casino Platform - Free Deployment Guide

## 🚀 Quick Deploy Options

### Option 1: Railway (Recommended) - Docker Deployment
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

1. **Create Railway Account**: Visit [railway.app](https://railway.app) and sign up
2. **Connect GitHub**: Link your GitHub account
3. **Upload Project**: Push this code to a GitHub repository
4. **Deploy**: Click "Deploy from GitHub repo" and select your repository
5. **Add MySQL**: In Railway dashboard, click "New" → "Database" → "MySQL"
6. **Environment Variables**: Railway will auto-configure database variables

**UPDATED**: Now uses Docker instead of Nixpacks to avoid PHP version conflicts:
- Uses PHP 8.1 with Apache in Docker container
- Includes all required PHP extensions (gmp, bcmath, zip, etc.)
- Automatically installs dependencies and runs migrations
- More reliable and consistent deployment

### Option 2: Heroku
[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

1. **Create Heroku Account**: Visit [heroku.com](https://heroku.com) and sign up
2. **Click Deploy Button**: Use the button above or manually create app
3. **Add ClearDB**: Go to Resources tab → Add ClearDB MySQL addon (free tier)
4. **Configure Variables**: Set environment variables in Settings tab

### Option 3: Render.com (New Alternative)
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com)

1. **Create Render Account**: Visit [render.com](https://render.com) and sign up
2. **Connect GitHub**: Link your GitHub repository
3. **Create Blueprint**: Use the `render.yaml` file for automatic setup
4. **Deploy**: Render will automatically create web service and database
5. **Free Tier**: 750 hours/month free (enough for testing)

### Option 4: InfinityFree
1. **Sign up**: Visit [infinityfree.net](https://infinityfree.net)
2. **Create Account**: Free hosting with PHP 8.1+ support
3. **Upload Files**: Use File Manager or FTP to upload project files
4. **Create Database**: Use MySQL Database Wizard in control panel
5. **Configure**: Update `.env` file with database credentials

### Option 5: Local Development with Docker
```bash
# Clone and run locally
git clone <your-repo>
cd Online-casino-script
docker-compose up -d
```
Access at: http://localhost

## 🔧 Manual Setup Steps

### 1. Environment Configuration
```bash
# Copy environment file
cp .env.install .env

# Generate application key
php artisan key:generate

# Run migrations
php artisan migrate --force

# Seed database (optional)
php artisan db:seed --force
```

### Docker Deployment (All Platforms)
The project now includes Docker support for consistent deployment:
- **Dockerfile**: PHP 8.1 + Apache with all extensions
- **docker-compose.yml**: Local development with MySQL
- **render.yaml**: Render.com deployment configuration
- **.dockerignore**: Optimized build context

### 2. Required Environment Variables
```env
APP_KEY=base64:YOUR_GENERATED_KEY
APP_URL=https://your-domain.com
DB_HOST=your_db_host
DB_DATABASE=your_db_name
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
```

### 3. Payment Gateway Setup (After Deployment)
- **PayPal**: Get credentials from [developer.paypal.com](https://developer.paypal.com)
- **Stripe**: Get API keys from [dashboard.stripe.com](https://dashboard.stripe.com)
- **CoinPayments**: Register at [coinpayments.net](https://coinpayments.net)

### 4. Social Login Setup (Optional)
- **Facebook**: Create app at [developers.facebook.com](https://developers.facebook.com)
- **Google**: Setup OAuth at [console.developers.google.com](https://console.developers.google.com)

## 🎮 Game Configuration

After deployment, configure games in the admin panel:
1. Login as admin
2. Go to Admin → Games
3. Enable/disable game packages
4. Configure game settings and odds

## 🔒 Security Checklist

- [ ] Change default admin credentials
- [ ] Set `APP_DEBUG=false` in production
- [ ] Configure proper file permissions
- [ ] Set up SSL certificate (free with Let's Encrypt)
- [ ] Configure CSRF protection
- [ ] Set up backup strategy

## 📞 Support

- **Documentation**: Check `/documentation/index.html`
- **Telegram**: [t.me/script017](https://t.me/script017)
- **Discord**: [discord.gg/cryptocasino](https://discord.gg/cryptocasino)
- **Website**: [BuyCasinoScripts.com](https://buycasinoscripts.com)

## ⚠️ Important Notes

1. **Legal Compliance**: Ensure gambling is legal in your jurisdiction
2. **Licensing**: Obtain proper gambling licenses where required
3. **Age Verification**: Implement age verification systems
4. **Responsible Gaming**: Add responsible gaming features
5. **Data Protection**: Comply with GDPR/privacy regulations

## 🎯 Post-Deployment Tasks

1. **Test All Games**: Verify each game works correctly
2. **Payment Testing**: Test all payment methods in sandbox mode
3. **User Registration**: Test user signup/login flow
4. **Admin Panel**: Configure site settings and limits
5. **Mobile Testing**: Ensure mobile responsiveness
6. **Performance**: Monitor and optimize loading times

---

**Ready to launch your casino? Choose your deployment method above and get started!** 🚀
