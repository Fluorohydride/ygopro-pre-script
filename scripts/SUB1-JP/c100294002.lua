--武装新宇侠
--Script by 奥克斯
function c100294002.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,aux.FilterBoolFunction(Card.IsFusionSetCard,0x111),1,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c100294002.destg)
	e1:SetOperation(c100294002.desop)
	c:RegisterEffect(e1)
	--battle check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetOperation(c100294002.checkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100294002,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c100294002.spcon)
	e3:SetCost(c100294002.spcost)
	e3:SetTarget(c100294002.sptg)
	e3:SetOperation(c100294002.spop)
	c:RegisterEffect(e3)   
end
c100294002.material_setcode=0x8
function c100294002.filter(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(1) and Duel.GetMatchingGroupCount(c100294002.desfilter,tp,0,LOCATION_MZONE,nil,c:GetLevel())>0
end
function c100294002.desfilter(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv)
end
function c100294002.cfilter(c,g)
	local atk,lv=g:GetMinGroup(Card.GetLevel)
	return c:IsLevelBelow(lv) and c:IsFaceup()
end
function c100294002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100294002.filter,tp,LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return #g>0 end
	local dg=Duel.GetMatchingGroup(c100294002.cfilter,tp,0,LOCATION_MZONE,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function c100294002.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100294002.filter,tp,LOCATION_GRAVE,0,nil,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tg=g:Select(tp,1,1,nil)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	local dg=Duel.GetMatchingGroup(c100294002.desfilter,tp,0,LOCATION_MZONE,nil,tg:GetFirst():GetLevel())
	if #dg==0 then return end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c100294002.checkop(e)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(100294002+100)
	if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and ct==0 then
		c:RegisterFlagEffect(100294002+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100294002,0))
		--这张卡是已战破怪兽的状态,buff提示
	end
end
function c100294002.spcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(100294002+100)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c100294002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMatchingGroupCount(c100294002.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function c100294002.spfilter(c,e,tp,rc)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100294002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100294002.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100294002.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100294002.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,e:GetHandler())
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
end