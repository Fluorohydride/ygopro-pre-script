--トリックスター・フォクシーウィッチ
--Trickstar Foxy Witch
function c100225006.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FAIRY),2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100225006,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100225006)
	e1:SetTarget(c100225006.damtg)
	e1:SetOperation(c100225006.damop)
	c:RegisterEffect(e1)	
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100225006,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100225106)
	e2:SetCondition(c100225006.damcon)
	e2:SetTarget(c100225006.damtg2)
	e2:SetOperation(c100225006.damop2)
	c:RegisterEffect(e2)
end
function c100225006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c100225006.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)*200
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100225006.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c100225006.damfilter(c,e,tp)
	return c:IsSetCard(0xfb) and c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100225006.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c100225006.damfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c100225006.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100225006.damfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local d=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)*200
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
