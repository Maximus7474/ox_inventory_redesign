import { flip, FloatingPortal, offset, shift, useFloating, useTransitionStyles } from '@floating-ui/react';
import React from 'react';
import { isEnvBrowser } from './misc';
import { debugData } from './debugData';
import { imagepath } from '../store/imagepath';

debugData([
  {
    action: 'DamageCall',
    data: {
      HEAD: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: true,
        bleeding: false,
      },
      SPINE: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LARM: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RFOOT: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RHAND: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LFOOT: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      NECK: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RLEG: {
        severity: true,
        percent: 60,
        bullets: 6,
        broken: false,
        bleeding: true,
      },
      LLEG: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LOWER_BODY: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LHAND: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      UPPER_BODY: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RARM: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
    },
  },
]);

const getBodyPartImage = (part: string): string => `${imagepath}/body-images/${part}.png`;

export default function Body({ detaileddata }: { detaileddata: any }) {
  const [hoverData, setHoverData] = React.useState<boolean>(false);
  const [bodypart, setBodypart] = React.useState<string>('');
  const [bodydamagecal, setBodydamagecal] = React.useState<any>(detaileddata);

  const { refs, context, floatingStyles } = useFloating({
    middleware: [flip(), shift(), offset({ mainAxis: 15, crossAxis: -20 })],
    open: hoverData,
    placement: 'right-start',
  });
  const { isMounted, styles } = useTransitionStyles(context, {
    duration: 200,
  });
  const handleMouseMove = ({ clientX, clientY }: MouseEvent | React.MouseEvent<unknown, MouseEvent>) => {
    refs.setPositionReference({
      getBoundingClientRect() {
        return {
          width: 0,
          height: 0,
          x: clientX,
          y: clientY,
          left: clientX,
          top: clientY,
          right: clientX,
          bottom: clientY,
        };
      },
    });
  };
  React.useEffect(() => {
    window.addEventListener('mousemove', handleMouseMove);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);
  return (
    <div className="group" style={{ position: 'relative' }}>
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['UPPER_BODY']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Upperbody"
        src={getBodyPartImage('upperbody')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LOWER_BODY']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lowerbody"
        src={getBodyPartImage('lowerbody')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LLEG']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lleg"
        src={getBodyPartImage('lleg')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RLEG']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rleg"
        src={getBodyPartImage('rleg')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RARM']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rhand"
        src={getBodyPartImage('rarm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LARM']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Larm"
        src={getBodyPartImage('larm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LHAND']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lparm"
        src={getBodyPartImage('lpalm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['NECK']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Neck"
        src={getBodyPartImage('neck')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['HEAD']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Head"
        src={getBodyPartImage('head')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RHAND']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rarm"
        src={getBodyPartImage('rpalm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RFOOT']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="RFoot"
        src={getBodyPartImage('rfoot')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LFOOT']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="LFoot"
        src={getBodyPartImage('lfoot')}
      />
    </div>
  );
}
