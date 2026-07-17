import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const badgeVariants = cva(
  'inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-gloss-green focus:ring-offset-2',
  {
    variants: {
      variant: {
        default: 'border-transparent bg-gloss-green text-white',
        secondary: 'border-transparent bg-gloss-green-bg-light text-gloss-green',
        destructive: 'border-transparent bg-red-100 text-gloss-red',
        outline: 'text-gloss-text',
        warning: 'border-transparent bg-orange-100 text-gloss-orange',
      },
    },
    defaultVariants: {
      variant: 'default',
    },
  },
);

export interface BadgeProps extends React.HTMLAttributes<HTMLDivElement>, VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
  return <div className={cn(badgeVariants({ variant }), className)} {...props} />;
}

export { Badge, badgeVariants };
