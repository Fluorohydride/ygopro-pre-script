--リンク・インフライヤー
--Link In-Flyer
--Scripted by Eerie Code
function c101002003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002003,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101002003)
	e1:SetCondition(c101002003.spcon)
	e1:SetOperation(c101002003.spop)
	c:RegisterEffect(e1)
end
function c101002003.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101002003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local zone=Duel.GetLinkedZone(tp)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
end
