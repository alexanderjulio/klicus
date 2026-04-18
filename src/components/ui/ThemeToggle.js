'use client';

import { useState, useEffect } from 'react';
import { Sun, Moon } from 'lucide-react';
import { cn } from '@/lib/utils';

export default function ThemeToggle() {
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    // Check if user has a preference or if it was already set
    const savedTheme = localStorage.getItem('theme');
    const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    
    if (savedTheme === 'dark' || (!savedTheme && systemPrefersDark)) {
      setIsDark(true);
      document.documentElement.classList.add('dark');
    }
  }, []);

  const toggleTheme = () => {
    if (isDark) {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('theme', 'light');
      setIsDark(false);
    } else {
      document.documentElement.classList.add('dark');
      localStorage.setItem('theme', 'dark');
      setIsDark(true);
    }
  };

  return (
    <button
      onClick={toggleTheme}
      className={cn(
        "fixed bottom-8 right-8 z-50 p-4 rounded-full shadow-2xl transition-all hover:scale-110",
        "bg-white dark:bg-zinc-800 text-secondary dark:text-primary border border-border dark:border-white/10"
      )}
      aria-label="Toggle Theme"
    >
      {isDark ? <Sun size={24} /> : <Moon size={24} />}
    </button>
  );
}
