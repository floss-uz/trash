'use client'

import { useState } from 'react'
import clsx from 'clsx'

import { TinyWaveFormIcon } from '@/components/TinyWaveFormIcon'

export function AboutSection(props: React.ComponentPropsWithoutRef<'section'>) {
  let [isExpanded, setIsExpanded] = useState(false)

  return (
    <section {...props}>
      <h2 className="flex items-center font-mono text-sm/7 font-medium text-slate-900">
        <TinyWaveFormIcon
          colors={['fill-violet-300', 'fill-pink-300']}
          className="h-2.5 w-2.5"
        />
        <span className="ml-2.5">Ma'lumot</span>
      </h2>
      <p
        className={clsx(
          'mt-2 text-base/7 text-slate-700',
          !isExpanded && 'lg:line-clamp-4',
        )}
      >
        Biz ishonamizki, xatolardan saboq chiqarish – yuksalishning eng muhim
        yo'llaridan biri. O'zbek Open Source hamjamiyatining faol a'zolari
        sifatida, O'zbekistonlik IT hamkasblarimizning ba'zan uchrab turadigan
        nomaqbul yoki sifatsiz postlarini bu yerga yig'ib, ularning sabablarini
        birgalikda o'rganamiz. Maqsadimiz – bu tajribadan foydalanib, nafaqat
        O'zbek Open Source hamjamiyatidagi muloqotni yaxshilash, balki kengroq
        miqyosda – butun O'zbekiston IT ekotizimida sog'lom va professional
        muhitni rivojlantirishdir
      </p>
      {!isExpanded && (
        <button
          type="button"
          className="mt-2 hidden text-sm/6 font-bold text-pink-500 hover:text-pink-700 active:text-pink-900 lg:inline-block"
          onClick={() => setIsExpanded(true)}
        >
          Show more
        </button>
      )}
    </section>
  )
}
