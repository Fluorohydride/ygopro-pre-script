--ショートヴァレル・ドラゴン
--Miniborrel Dragon
--Script by nekrozar
function c101005040.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x102),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101005040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101005040)
	e1:SetCondition(c101005040.spcon)
	e1:SetCost(c101005040.spcost)
	e1:SetTarget(c101005040.sptg)
	e1:SetOperation(c101005040.spop)
	c:RegisterEffect(e1)
end
function c101005040.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function c101005040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101005040.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101005040.cfilter(c,tp)
	return c:IsLinkBelow(3) and Duel.GetMZoneCount(tp,c)>0
end
function c101005040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101005040.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c101005040.cfilter,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetLink())
	Duel.Release(sg,REASON_COST)
end
function c101005040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101005040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetTarget(c101005040.lklimit)
		e1:SetLabel(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101005040.lklimit(e,c)
	if not c then return false end
	local lk=e:GetLabel()
	return c:IsLink(lk)
end
